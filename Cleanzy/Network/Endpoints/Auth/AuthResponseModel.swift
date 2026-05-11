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
}

// MARK: - Type Aliases

typealias AuthSuccessResponse = BaseSuccessResponse<AuthResponseModel>
