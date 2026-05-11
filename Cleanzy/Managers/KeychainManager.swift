//
//  KeychainManager.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation
import Security

// MARK: - KeychainManager

final class KeychainManager {
    static let shared = KeychainManager()

    private init() { }

    private enum Keys {
        static let accessToken = "com.cleanzy.accessToken"
        static let userName = "com.cleanzy.userName"
    }
}

// MARK: - Access Token

extension KeychainManager {
    var accessToken: String? {
        read(for: Keys.accessToken)
    }

    @discardableResult
    func saveAccessToken(_ token: String) -> Bool {
        save(token, for: Keys.accessToken)
    }

    @discardableResult
    func deleteAccessToken() -> Bool {
        delete(for: Keys.accessToken)
    }
}

// MARK: - User Name

extension KeychainManager {
    var userName: String? {
        read(for: Keys.userName)
    }

    @discardableResult
    func saveUserName(_ name: String) -> Bool {
        save(name, for: Keys.userName)
    }

    @discardableResult
    func deleteUserName() -> Bool {
        delete(for: Keys.userName)
    }

    func clearSession() {
        deleteAccessToken()
        deleteUserName()
    }
}

// MARK: - Private Keychain Operations

private extension KeychainManager {
    func save(_ value: String, for key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    func read(for key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8)
        else { return nil }

        return value
    }

    @discardableResult
    func delete(for key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]

        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
