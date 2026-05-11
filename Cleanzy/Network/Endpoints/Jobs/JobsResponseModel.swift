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

    var displayTitle: String {
        switch self {
        case .OPEN:        return "Açık"
        case .ASSIGNED:    return "Atandı"
        case .IN_PROGRESS: return "Devam Ediyor"
        case .COMPLETED:   return "Tamamlandı"
        case .CANCELLED:   return "İptal Edildi"
        }
    }
}

// MARK: - JobResponseModel

struct JobResponseModel: Codable {
    let id: Int?
    let cleanerID: Int?
    let customerID: Int?
    let customer: CustomerSummaryModel?
    let assignedCleaner: CleanerSummaryModel?
    let address: String?
    let scheduledDate: String?
    let scheduledTime: String?
    let houseSize: String?
    let extraServices: [String]?
    let price: Double?
    let status: JobStatus?
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - Type Aliases

typealias JobSuccessResponse     = BaseSuccessResponse<JobResponseModel>
typealias JobListSuccessResponse = BaseSuccessResponse<[JobResponseModel]>
