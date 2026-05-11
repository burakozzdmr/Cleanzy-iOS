//
//  UserModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.11.2025.
//

import Foundation

struct UserModel: Codable {
    let userID: String
    let email: String
    let phoneNumber: String
    let userName: String
    let userType: UserType
    let profilePhotoData: Data?
}
