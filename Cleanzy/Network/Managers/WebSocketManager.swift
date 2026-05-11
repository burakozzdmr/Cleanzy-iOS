//
//  WebSocketManager.swift
//  Cleanzy
//

import Foundation

// MARK: - WebSocketManager
//
// Implements a minimal STOMP client over URLSessionWebSocketTask.
// STOMP is a text-based protocol; no third-party library is required.
//
// Frame format:
//   COMMAND\n
//   header1:value1\n
//   \n
//   body\0
//
// Typical connect sequence:
//   Client → CONNECT (with Authorization)
//   Server → CONNECTED
//   Client → SUBSCRIBE (destination: /topic/conversation.{id})
//   Client ↔ SEND / MESSAGE  (real-time exchange)
//   Client → DISCONNECT

final class WebSocketManager {

    // MARK: - Shared Instance

    static let shared = WebSocketManager()

    // MARK: - Public Callbacks

    var onMessageReceived: ((MessageResponseModel) -> Void)?
    var onConnected: (() -> Void)?
    var onError: ((Error?) -> Void)?

    // MARK: - Private State

    private var webSocketTask: URLSessionWebSocketTask?
    private var session: URLSession = .shared
    private var subscribedConversationId: Int?
    private var isConnected = false

    private init() { }

    // MARK: - Public API

    /// Opens the WebSocket, sends STOMP CONNECT, then subscribes to the conversation topic.
    func connect(conversationId: Int) {
        guard let url = URL(string: NetworkConstants.wsPath) else { return }

        subscribedConversationId = conversationId
        isConnected = false

        let request = URLRequest(url: url)
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()

        sendStompConnect()
        listenForMessages()
    }

    /// Sends a chat message via STOMP SEND to /app/chat.send.
    func send(conversationId: Int, content: String, senderId: Int) {
        guard isConnected else { return }

        let bodyDict: [String: Any] = [
            "conversationId": conversationId,
            "senderId": senderId,
            "content": content
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyDict),
              let bodyString = String(data: bodyData, encoding: .utf8) else { return }

        let frame = stompFrame(
            command: "SEND",
            headers: ["destination": "/app/chat.send", "content-type": "application/json"],
            body: bodyString
        )
        sendFrame(frame)
    }

    /// Sends STOMP DISCONNECT and closes the WebSocket task.
    func disconnect() {
        guard let task = webSocketTask else { return }

        let frame = stompFrame(command: "DISCONNECT", headers: [:], body: nil)
        task.send(.string(frame)) { [weak self] _ in
            self?.webSocketTask?.cancel(with: .normalClosure, reason: nil)
            self?.webSocketTask = nil
            self?.isConnected = false
        }
    }

    // MARK: - Private — STOMP Framing

    private func sendStompConnect() {
        let token = KeychainManager.shared.accessToken ?? ""
        let frame = stompFrame(
            command: "CONNECT",
            headers: [
                "accept-version": "1.2",
                "heart-beat": "10000,10000",
                "Authorization": "Bearer \(token)"
            ],
            body: nil
        )
        sendFrame(frame)
    }

    private func sendStompSubscribe(conversationId: Int) {
        let frame = stompFrame(
            command: "SUBSCRIBE",
            headers: [
                "id": "sub-\(conversationId)",
                "destination": "/topic/conversation.\(conversationId)"
            ],
            body: nil
        )
        sendFrame(frame)
    }

    private func stompFrame(command: String, headers: [String: String], body: String?) -> String {
        var frame = command + "\n"
        for (key, value) in headers {
            frame += "\(key):\(value)\n"
        }
        frame += "\n"
        if let body {
            frame += body
        }
        frame += "\0"
        return frame
    }

    private func sendFrame(_ frame: String) {
        webSocketTask?.send(.string(frame)) { [weak self] error in
            if let error {
                self?.onError?(error)
            }
        }
    }

    // MARK: - Private — Receive Loop

    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleFrame(text)
                case .data:
                    break
                @unknown default:
                    break
                }
                // Keep listening
                self.listenForMessages()

            case .failure(let error):
                self.isConnected = false
                self.onError?(error)
            }
        }
    }

    // MARK: - Private — Frame Handling

    private func handleFrame(_ raw: String) {
        let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        // Heartbeat / empty frames
        if text.isEmpty || text == "\n" { return }

        let command = text.components(separatedBy: "\n").first ?? ""

        switch command {
        case "CONNECTED":
            isConnected = true
            if let convId = subscribedConversationId {
                sendStompSubscribe(conversationId: convId)
            }
            DispatchQueue.main.async { self.onConnected?() }

        case "MESSAGE":
            parseMessageFrame(text)

        case "ERROR":
            DispatchQueue.main.async { self.onError?(nil) }

        default:
            break
        }
    }

    /// Parses the STOMP MESSAGE frame body as a `MessageResponseDTO` JSON.
    private func parseMessageFrame(_ frame: String) {
        // Frame: "MESSAGE\nheader:value\n...\n\nbody\0"
        guard let separatorRange = frame.range(of: "\n\n") else { return }
        let bodyWithNull = String(frame[separatorRange.upperBound...])
        let body = bodyWithNull.replacingOccurrences(of: "\0", with: "")

        guard let data = body.data(using: .utf8) else { return }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let model = try? decoder.decode(MessageResponseModel.self, from: data) {
            DispatchQueue.main.async { self.onMessageReceived?(model) }
        }
    }
}
