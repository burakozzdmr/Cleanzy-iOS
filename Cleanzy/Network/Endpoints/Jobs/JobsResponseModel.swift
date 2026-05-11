//
//  JobsResponseModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - JobStatus

enum JobStatus: String, Codable {
    case OPEN
    case ASSIGNED
    case IN_PROGRESS
    case COMPLETED
    case CANCELLED
}

// MARK: - JobResponseModel

struct JobResponseModel: Codable {
    let id: Int?
    let customer: CustomerSummaryModel?
    let title: String?
    let description: String?
    let address: String?
    let city: String?
    let price: Double?
    let scheduledAt: Date?
    let status: JobStatus?
    let assignedCleaner: CleanerSummaryModel?
    let createdAt: Date?
    let updatedAt: Date?
}

// MARK: - Type Aliases

typealias JobSuccessResponse = BaseSuccessResponse<JobResponseModel>
typealias JobListSuccessResponse = BaseSuccessResponse<[JobResponseModel]>
