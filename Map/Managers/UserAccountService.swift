//
//  UserAccountService.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 15.07.2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UserAccountService {

    private let authService: Auth

    init() {
        self.authService = Auth.auth()
    }

    public func signIn(withEmail: String, password: String, _ completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        authService.signIn(withEmail: withEmail, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(result))
        }
    }

    public func signOut(_ completion: @escaping (Result<String, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success("Signed out"))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }

}
