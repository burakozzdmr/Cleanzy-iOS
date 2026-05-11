//
//  BaseSuccessResponse.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

class BaseSuccessResponse<T: Codable>: Codable {
    var success: Bool
    var totalResults: Int?   // Backend bazen döndürmüyor
    var timestamp: String    // "2026-05-11T17:27:18.15181" → custom format, String olarak tutuyoruz
    var data: T
}
