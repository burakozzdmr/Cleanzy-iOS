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
