//
//  ProfileRequestModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - GetProfileRequestModel

struct GetProfileRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.mePath + "/\(userId)" }
    var method: HTTPMethod { .GET }

    let userId: Int
}

// MARK: - UpdateProfileRequestModel

struct UpdateProfileRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.profilePath + "/\(userId)" }
    var method: HTTPMethod { .PATCH }

    let userId: Int
    let fullName: String
    let email: String
    let currentLocation: String

    var body: Data? {
        try? JSONEncoder().encode(
            UpdateBody(fullName: fullName, email: email, currentLocation: currentLocation)
        )
    }

    private struct UpdateBody: Encodable {
        let fullName: String
        let email: String
        let currentLocation: String
    }
}
