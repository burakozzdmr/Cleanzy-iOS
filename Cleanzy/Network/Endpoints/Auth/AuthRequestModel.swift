//
//  AuthRequestModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - LoginRequestModel

struct LoginRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.authPath + "/login" }
    var method: HTTPMethod { .POST }

    let email: String
    let password: String

    var body: Data? {
        try? JSONEncoder().encode(LoginBody(email: email, password: password))
    }

    private struct LoginBody: Encodable {
        let email: String
        let password: String
    }
}

// MARK: - RegisterRequestModel

struct RegisterRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.authPath + "/register" }
    var method: HTTPMethod { .POST }

    let fullName: String
    let email: String
    let password: String
    let role: String

    var body: Data? {
        try? JSONEncoder().encode(RegisterBody(fullName: fullName, email: email, password: password, role: role))
    }

    private struct RegisterBody: Encodable {
        let fullName: String
        let email: String
        let password: String
        let role: String
    }
}

// MARK: - LogoutRequestModel

struct LogoutRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.authPath + "/logout" }
    var method: HTTPMethod { .POST }
}

// MARK: - RefreshTokenRequestModel

struct RefreshTokenRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.authPath + "/refresh" }
    var method: HTTPMethod { .POST }

    let token: String

    var body: Data? {
        try? JSONEncoder().encode(RefreshBody(token: token))
    }

    private struct RefreshBody: Encodable {
        let token: String
    }
}

// MARK: - ChangePasswordRequestModel

struct ChangePasswordRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.authPath + "/change-password" }
    var method: HTTPMethod { .PATCH }

    let currentPassword: String
    let newPassword: String

    var body: Data? {
        try? JSONEncoder().encode(ChangePasswordBody(currentPassword: currentPassword, newPassword: newPassword))
    }

    private struct ChangePasswordBody: Encodable {
        let currentPassword: String
        let newPassword: String
    }
}
