//
//  AppointmentsItems.swift
//  Cleanzy
//

import UIKit

// MARK: - AppointmentItem

struct AppointmentItem {
    let id: Int
    let cleanerName: String
    let address: String
    let scheduledDate: String
    let scheduledTime: String
    let houseSize: String
    let price: Double
    let status: JobStatus
    let extraServices: [String]

    var formattedPrice: String { "₺\(Int(price))" }
    var statusColor: UIColor {
        switch status {
        case .OPEN:        return .systemOrange
        case .ASSIGNED:    return .systemBlue
        case .IN_PROGRESS: return .systemYellow
        case .COMPLETED:   return .systemGreen
        case .CANCELLED:   return .systemRed
        }
    }

    init(from model: JobResponseModel) {
        self.id            = model.id ?? 0
        self.cleanerName   = model.assignedCleaner?.fullName ?? "Henüz atanmadı"
        self.address       = model.address ?? "-"
        self.scheduledDate = model.scheduledDate ?? "-"
        self.scheduledTime = model.scheduledTime ?? "-"
        self.houseSize     = model.houseSize ?? "-"
        self.price         = model.price ?? 0
        self.status        = model.status ?? .OPEN
        self.extraServices = model.extraServices ?? []
    }
}
