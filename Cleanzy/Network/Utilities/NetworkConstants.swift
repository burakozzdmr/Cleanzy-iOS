//
//  NetworkConstants.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

enum NetworkConstants {
    static let baseURL: String = "http://localhost:8080"
    static let timeout: TimeInterval = 60
    static let apiNamespace = "/rest"
    static let apiRoot = "/api"
    static let apiVersion = "/v1"
    static let basePath = baseURL + apiNamespace + apiRoot + apiVersion

    enum Headers {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    enum HeaderValues {
        static let json = "application/json"
        static let bearer = "Bearer "
    }
    
    enum Endpoints {
        static let jobsPath           = "/jobs"
        static let favoritesPath      = "/favorites"
        static let authPath           = "/auth"
        static let profilePath        = "/profile"
        static let mePath             = "/profile/me"
        static let customersPath      = "/customers"
        static let cleanersPath       = "/cleaners"
        static let conversationsPath  = "/conversations"
        static let reviewsPath        = "/reviews"
    }
}
