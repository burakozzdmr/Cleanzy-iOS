//
//  JobsRequestModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - GetAllJobsRequestModel

struct GetAllJobsRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath }
    var method: HTTPMethod { .GET }
}

// MARK: - GetMyJobsRequestModel

struct GetMyJobsRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/my" }
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
    var path: String { NetworkConstants.Endpoints.jobsPath }
    var method: HTTPMethod { .POST }

    let cleanerID: Int
    let customerID: Int
    let address: String
    let scheduledDate: String   // "yyyy-MM-dd"
    let scheduledTime: String   // "HH:mm"
    let houseSize: String       // "SMALL" | "MEDIUM" | "LARGE" | "ULTRA_LARGE"
    let extraServices: [String] // e.g. ["WINDOW_CLEANING"]

    var body: Data? {
        try? JSONEncoder().encode(
            JobBody(
                cleanerID: cleanerID,
                customerID: customerID,
                address: address,
                scheduledDate: scheduledDate,
                scheduledTime: scheduledTime,
                houseSize: houseSize,
                extraServices: extraServices
            )
        )
    }

    private struct JobBody: Encodable {
        let cleanerID: Int
        let customerID: Int
        let address: String
        let scheduledDate: String
        let scheduledTime: String
        let houseSize: String
        let extraServices: [String]
    }
}

// MARK: - UpdateJobStatusRequestModel

struct UpdateJobStatusRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/\(jobID)/status" }
    var method: HTTPMethod { .PATCH }

    let jobID: Int
    let status: String

    var body: Data? {
        try? JSONEncoder().encode(StatusBody(status: status))
    }

    private struct StatusBody: Encodable {
        let status: String
    }
}

// MARK: - DeleteJobRequestModel

struct DeleteJobRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.jobsPath + "/\(jobID)" }
    var method: HTTPMethod { .DELETE }

    let jobID: Int
}
