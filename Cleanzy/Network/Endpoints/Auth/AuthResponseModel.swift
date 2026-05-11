//
//  AuthResponseModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - AuthResponseModel

struct AuthResponseModel: Codable {
    let accessToken: String
    let userId: Int
    let role: String
    let fullName: String
    let email: String
}

// MARK: - Type Aliases

typealias AuthSuccessResponse = BaseSuccessResponse<AuthResponseModel>
