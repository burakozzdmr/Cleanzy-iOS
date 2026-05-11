//
//  BaseSuccessResponse.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

class BaseSuccessResponse<T: Codable>: Codable {
    var success: Bool
    var totalResults: Int
    var timestamp: Date
    var data: T
}
