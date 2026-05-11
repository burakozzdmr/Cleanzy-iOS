//
//  BaseErrorResponse.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

protocol BaseErrorResponse: Codable {
    var success: Bool { get }
    var timestamp: Date { get }
    var errorDetails: ErrorDetails? { get }
}
