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
        static let accessToken  = "com.cleanzy.accessToken"
        static let userName     = "com.cleanzy.userName"
        static let userEmail    = "com.cleanzy.userEmail"
        static let userId       = "com.cleanzy.userId"
        static let userRole     = "com.cleanzy.userRole"
    }
}

// MARK: - Access Token

extension KeychainManager {
    var accessToken: String? { read(for: Keys.accessToken) }

    @discardableResult func saveAccessToken(_ token: String) -> Bool { save(token, for: Keys.accessToken) }
    @discardableResult func deleteAccessToken() -> Bool { delete(for: Keys.accessToken) }
}

// MARK: - User Name

extension KeychainManager {
    var userName: String? { read(for: Keys.userName) }

    @discardableResult func saveUserName(_ name: String) -> Bool { save(name, for: Keys.userName) }
    @discardableResult func deleteUserName() -> Bool { delete(for: Keys.userName) }
}

// MARK: - User Email

extension KeychainManager {
    var userEmail: String? { read(for: Keys.userEmail) }

    @discardableResult func saveUserEmail(_ email: String) -> Bool { save(email, for: Keys.userEmail) }
    @discardableResult func deleteUserEmail() -> Bool { delete(for: Keys.userEmail) }
}

// MARK: - User ID

extension KeychainManager {
    var userId: Int? {
        guard let str = read(for: Keys.userId) else { return nil }
        return Int(str)
    }

    @discardableResult func saveUserId(_ id: Int) -> Bool { save(String(id), for: Keys.userId) }
    @discardableResult func deleteUserId() -> Bool { delete(for: Keys.userId) }
}

// MARK: - User Role

extension KeychainManager {
    var userRole: String? { read(for: Keys.userRole) }

    @discardableResult func saveUserRole(_ role: String) -> Bool { save(role, for: Keys.userRole) }
    @discardableResult func deleteUserRole() -> Bool { delete(for: Keys.userRole) }
}

// MARK: - Session

extension KeychainManager {
    func clearSession() {
        deleteAccessToken()
        deleteUserName()
        deleteUserEmail()
        deleteUserId()
        deleteUserRole()
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
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }
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
