//
//  CleanersRequestModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - GetCleanerListRequestModel

struct GetCleanerListRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.cleanersPath + "/" }
    var method: HTTPMethod { .GET }
}

// MARK: - GetCleanerByIDRequestModel

struct GetCleanerByIDRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.cleanersPath + "/\(cleanerID)" }
    var method: HTTPMethod { .GET }

    let cleanerID: Int
}
