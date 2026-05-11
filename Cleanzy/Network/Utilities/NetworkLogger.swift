//
//  NetworkLogger.swift
//  Cleanzy
//

import Foundation

// MARK: - NetworkLogger
// Debug build only — production'da hiçbir şey print etmez.

final class NetworkLogger {

    static func logRequest(_ request: URLRequest) {
        #if DEBUG
        let method = request.httpMethod ?? "?"
        let url    = request.url?.absoluteString ?? "?"

        var log  = "\n┌──────────────── 📤 REQUEST ────────────────\n"
        log     += "│ \(method) \(url)\n"

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            log += "│ Headers:\n"
            headers.forEach { log += "│   \($0.key): \($0.value)\n" }
        }

        if let body = request.httpBody,
           let json = prettyJSON(from: body) {
            log += "│ Body:\n"
            json.split(separator: "\n").forEach { log += "│   \($0)\n" }
        }

        log += "└────────────────────────────────────────────"
        print(log)
        #endif
    }

    static func logResponse(data: Data, response: URLResponse) {
        #if DEBUG
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let url        = response.url?.absoluteString ?? "?"
        let emoji      = (200...299).contains(statusCode) ? "✅" : "❌"

        var log  = "\n┌──────────────── \(emoji) RESPONSE ────────────────\n"
        log     += "│ \(statusCode) \(url)\n"

        if let json = prettyJSON(from: data) {
            json.split(separator: "\n").forEach { log += "│   \($0)\n" }
        } else if let raw = String(data: data, encoding: .utf8) {
            log += "│ Raw: \(raw)\n"
        }

        log += "└──────────────────────────────────────────────"
        print(log)
        #endif
    }

    static func logError(_ error: Error, url: String? = nil) {
        #if DEBUG
        var log  = "\n┌──────────────── ⚠️  NETWORK ERROR ────────────────\n"
        if let url { log += "│ URL: \(url)\n" }
        log     += "│ Error: \(error)\n"
        log     += "└────────────────────────────────────────────────────"
        print(log)
        #endif
    }

    // MARK: - Private

    private static func prettyJSON(from data: Data) -> String? {
        guard let obj = try? JSONSerialization.jsonObject(with: data),
              let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted]),
              let str = String(data: pretty, encoding: .utf8) else { return nil }
        return str
    }
}
