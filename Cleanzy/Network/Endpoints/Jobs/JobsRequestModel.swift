//
//  JobsRequestModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - GetAllJobsRequestModel

struct GetAllJobsRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/" }
    var method: HTTPMethod { .GET }
}

// MARK: - GetJobByIDRequestModel

struct GetJobByIDRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/\(jobID)" }
    var method: HTTPMethod { .GET }

    let jobID: Int
}

// MARK: - AddJobRequestModel

struct AddJobRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/" }
    var method: HTTPMethod { .POST }

    // JobRequestDTO is currently an empty schema on the backend.
    // Add fields here as the backend schema evolves.
    var body: Data? { try? JSONEncoder().encode(EmptyBody()) }

    private struct EmptyBody: Encodable {}
}

// MARK: - UpdateJobRequestModel

struct UpdateJobRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/" }
    var method: HTTPMethod { .PATCH }

    // JobRequestDTO is currently an empty schema on the backend.
    // Add fields here as the backend schema evolves.
    var body: Data? { try? JSONEncoder().encode(EmptyBody()) }

    private struct EmptyBody: Encodable {}
}

// MARK: - DeleteJobRequestModel

struct DeleteJobRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/" }
    var method: HTTPMethod { .DELETE }
}
