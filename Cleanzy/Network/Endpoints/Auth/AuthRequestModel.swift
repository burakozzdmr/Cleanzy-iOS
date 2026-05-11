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

    var body: Data? {
        try? JSONEncoder().encode(RegisterBody(fullName: fullName, email: email, password: password))
    }

    private struct RegisterBody: Encodable {
        let fullName: String
        let email: String
        let password: String
    }
}
