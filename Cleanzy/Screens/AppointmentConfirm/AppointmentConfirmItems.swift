//
//  AppointmentConfirmItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - AppointmentConfirmItem

struct AppointmentConfirmItem {
    let serviceSummary: String
    let formattedDate: String
    let timeSlot: String

    static func build(houseSize: HouseSize, date: Date?, timeSlot: String?) -> AppointmentConfirmItem {
        let serviceSummary = "\(houseSize.rawValue) Ev Temizliği"

        let formattedDate: String
        if let date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            formatter.dateFormat = "d MMMM yyyy, EEEE"
            formattedDate = formatter.string(from: date)
        } else {
            formattedDate = "-"
        }

        return AppointmentConfirmItem(
            serviceSummary: serviceSummary,
            formattedDate: formattedDate,
            timeSlot: timeSlot ?? "-"
        )
    }
}
