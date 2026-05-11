//
//  AuthenticationError .swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.11.2025.
//

import Foundation

enum AuthenticationError: Error {
    case invalidEmail
    case invalidPassword
    case signInFailed
    case signUpFailed
    case signOutFailed
    case sendResetPasswordFailed
    case userNotFound
    case userAlreadyExists
    case decodingError
    case userTypeMismatch
    case firebaseError(Error)
    
    var errorMessage: String {
        switch self {
        case .invalidEmail:
            return "Invalid email"
        case .invalidPassword:
            return "Invalid password"
        case .signInFailed:
            return "Sign in failed"
        case .signUpFailed:
            return "Sign up failed"
        case .signOutFailed:
            return "Sign out failed"
        case .sendResetPasswordFailed:
            return "Send reset password failed"
        case .userNotFound:
            return "User not found"
        case .userAlreadyExists:
            return "User already exists"
        case .decodingError:
            return "Decoding error"
        case .userTypeMismatch:
            return "User type mismatch"
        case .firebaseError(let error):
            return error.localizedDescription
        }
    }
}
