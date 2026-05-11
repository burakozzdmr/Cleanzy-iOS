//
//  NetworkError.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case timeOut
    case serverError
    case noInternetConnection
    case decodeError
    case emptyData
    case invalidResponse
    case statusCode(Int)
    case general(Error)
    case apiError(APIError)
    
    static func from(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 408: return .timeOut
        case 500...599: return .serverError
        default: return .statusCode(statusCode)
        }
    }

    var networkErrorMessage: String {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidRequest:
            return "Geçersiz API isteği."
        case .badRequest:
            return "Hatalı istek"
        case .unauthorized:
            return "Yetkisiz erişim"
        case .forbidden:
            return "Erişim yasak"
        case .notFound:
            return "Kaynak bulunamadı"
        case .timeOut:
            return "İstek zaman aşımına uğradı"
        case .serverError:
            return "Sunucu hatası"
        case .noInternetConnection:
            return "İnternet bağlantısı yok"
        case .decodeError:
            return "Veri işlenirken hata oluştu"
        case .emptyData:
            return "Veri bulunamadı"
        case .invalidResponse:
            return "Geçersiz veri."
        case .statusCode(let code):
            return "Hata kodu: \(code)"
        case .general(let error):
            return "Bilinmeyen bir hata oluştu -> \(error.localizedDescription)"
        case .apiError(let apiError):
            return apiError.apiErrorMessage
        }
    }
}

enum APIError: Error {
    case AUTHENTICATION_ERROR
    case USER_NOT_FOUND
    case AUTHORIZATION_FOUND
    case USER_ALREADY_EXISTS
    case CUSTOMER_NOT_FOUND
    case CLEANER_NOT_FOUND
    case JOB_NOT_FOUND
    case FAVORITE_NOT_FOUND
    case ALREADY_FAVORITED
    case VALIDATION_ERROR
    
    var apiErrorMessage: String {
        switch self {
        case .AUTHENTICATION_ERROR:
            return "Kimlik doğrulama hatası"
        case .USER_NOT_FOUND:
            return "Kullanıcı bulunamadı"
        case .AUTHORIZATION_FOUND:
            return "Yetkilendirme hatası"
        case .USER_ALREADY_EXISTS:
            return "Bu kullanıcı zaten kayıtlı"
        case .CUSTOMER_NOT_FOUND:
            return "Müşteri bulunamadı"
        case .CLEANER_NOT_FOUND:
            return "Temizlikçi bulunamadı"
        case .JOB_NOT_FOUND:
            return "İş bulunamadı"
        case .FAVORITE_NOT_FOUND:
            return "Favori bulunamadı"
        case .ALREADY_FAVORITED:
            return "Zaten favorilere eklendi"
        case .VALIDATION_ERROR:
            return "Doğrulama hatası"
        }
    }
}
