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
    let address: String
    let totalAmount: String
    let paymentCard: String
    let cleanerName: String

    static func build(
        houseSize: HouseSize,
        date: Date?,
        timeSlot: String?,
        address: String = "",
        totalAmount: String = "",
        paymentCard: String = "Nakit",
        cleanerName: String = ""
    ) -> AppointmentConfirmItem {
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
            timeSlot: timeSlot ?? "-",
            address: address.isEmpty ? "-" : address,
            totalAmount: totalAmount.isEmpty ? "-" : totalAmount,
            paymentCard: paymentCard,
            cleanerName: cleanerName.isEmpty ? "-" : cleanerName
        )
    }
}
