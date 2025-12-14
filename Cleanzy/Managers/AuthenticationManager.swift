//
//  AuthenticationManager.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 9.11.2025.
//

import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

protocol AuthenticationManagerProtocol {
    func signIn(with email: String, and password: String, as userTypeIndex: Int) -> AnyPublisher<AuthDataResult, AuthenticationError>
    func signUp(with email: String, and password: String, as userTypeIndex: Int) -> AnyPublisher<AuthDataResult, AuthenticationError>
    func signOut() -> AnyPublisher<Void, AuthenticationError>
    func sendResetPasswordLink(with email: String) -> AnyPublisher<Void, AuthenticationError>
}

// MARK: - AuthenticationManager

final class AuthenticationManager {
    private let firebaseAuthentication = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    
    var currentUser: User? {
        firebaseAuthentication.currentUser
    }
}

// MARK: - AuthenticationManagerProtocol

extension AuthenticationManager: AuthenticationManagerProtocol {
    func signIn(with email: String, and password: String, as userTypeIndex: Int) -> AnyPublisher<AuthDataResult, AuthenticationError> {
        let selectedUserType: UserType = .init(rawValue: userTypeIndex) ?? .customer
        
        return firebaseAuthentication
            .signIn(withEmail: email, password: password)
            .mapError { error in
                AuthenticationError.firebaseError(error)
            }
            .flatMap { [weak self] authResult -> AnyPublisher<AuthDataResult, AuthenticationError> in
                guard let self = self else {
                    return Fail(error: AuthenticationError.signInFailed)
                        .eraseToAnyPublisher()
                }
                
                return self.fetchUserFromFirestore(for: authResult.user.uid)
                    .tryMap { userModel -> AuthDataResult in
                        if userModel.userType != selectedUserType {
                            throw AuthenticationError.userTypeMismatch
                        }
                        return authResult
                    }
                    .mapError { error in
                        if let authError = error as? AuthenticationError {
                            return authError
                        }
                        return AuthenticationError.firebaseError(error)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func signUp(with email: String, and password: String, as userTypeIndex: Int) -> AnyPublisher<AuthDataResult, AuthenticationError> {
        let selectedUserType: UserType = .init(rawValue: userTypeIndex) ?? .customer
        
        return firebaseAuthentication
            .createUser(withEmail: email, password: password)
            .mapError { _ in
                AuthenticationError.signUpFailed
            }
            .flatMap { [weak self] authResult -> AnyPublisher<AuthDataResult, AuthenticationError> in
                guard let self = self else {
                    return Fail(error: AuthenticationError.signUpFailed)
                        .eraseToAnyPublisher()
                }
                
                let userModel = UserModel(
                    userID: authResult.user.uid,
                    email: authResult.user.email ?? "",
                    phoneNumber: authResult.user.phoneNumber ?? "",
                    userName: "",
                    userType: selectedUserType,
                    profilePhotoData: nil
                )
                
                return self.saveUserToFirestore(with: userModel)
                    .map { authResult }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, AuthenticationError> {
        return Future<Void, AuthenticationError> { [weak self] promise in
            do {
                try self?.firebaseAuthentication.signOut()
                promise(.success(()))
            } catch {
                promise(.failure(AuthenticationError.signOutFailed))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func sendResetPasswordLink(with email: String) -> AnyPublisher<Void, AuthenticationError> {
        return firebaseAuthentication
            .sendPasswordReset(withEmail: email)
            .mapError { _ in
                AuthenticationError.sendResetPasswordFailed
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Privates

private extension AuthenticationManager {
    func fetchUserFromFirestore(for userID: String) -> AnyPublisher<UserModel, AuthenticationError> {
        return firebaseFirestore
            .collection("USERS")
            .document(userID)
            .getDocument()
            .tryMap { document -> UserModel in
                guard document.exists else {
                    throw AuthenticationError.userNotFound
                }
                
                guard let documentData = document.data(),
                      let userID = documentData["USER_ID"] as? String,
                      let userName = documentData["USER_NAME"] as? String,
                      let email = documentData["EMAIL"] as? String,
                      let phoneNumber = documentData["PHONE_NUMBER"] as? String,
                      let userTypeIndex = documentData["USER_TYPE_INDEX"] as? Int
                else {
                    throw AuthenticationError.userNotFound
                }
                
                return UserModel(
                    userID: userID,
                    email: email,
                    phoneNumber: phoneNumber,
                    userName: userName,
                    userType: UserType(rawValue: userTypeIndex) ?? .customer,
                    profilePhotoData: nil
                )
            }
            .mapError { error in
                AuthenticationError.userNotFound
            }
            .eraseToAnyPublisher()
    }
    
    func saveUserToFirestore(with userModel: UserModel) -> AnyPublisher<Void, AuthenticationError> {
        let newUserData: [String: Any] = [
            "USER_ID": userModel.userID,
            "USER_NAME": userModel.userName,
            "EMAIL": userModel.email,
            "PHONE_NUMBER": userModel.phoneNumber,
            "USER_TYPE_INDEX": userModel.userType.rawValue
        ]
        
        return firebaseFirestore
            .collection("USERS")
            .document(userModel.userID)
            .setData(newUserData)
            .mapError { _ in
                AuthenticationError.signUpFailed
            }
            .eraseToAnyPublisher()
    }
}
