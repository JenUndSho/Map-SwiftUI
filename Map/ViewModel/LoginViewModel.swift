//
//  LoginViewModel.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 13.06.2024.
//

import Foundation
import FirebaseAuth

enum TextFieldError: Error, LocalizedError {
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case invalidPassword

    var description: String {
        switch self {
        case .emptyEmail:
            return "Please enter email"
        case .emptyPassword:
            return "Please enter password"
        case .invalidEmail:
            return "Please enter valid email"
        case .invalidPassword:
            return "Please enter valid password"
        }
    }
}

// https://regexlib.com/
enum TextFieldType: String {

    case email = "^[A-Za-z0-9._]{3,64}[\\d\\w](@{1})([A-Za-z0-9]{2,}\\.[A-Za-z0-9]{2,})$"
//    case email = "/^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$/g"
    // Password matching expression. Password must be at least 8 characters, no more than 15 characters, and must include at least one upper case letter, one lower case letter, and one numeric digit.
    case password = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$"
}

class LoginViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailError: TextFieldError?
    @Published var passwordError: TextFieldError?

    private let analyticsManager: FirebaseAnalyticsManager = .shared
    private let authService = UserAccountService()

    var isValidInput: Bool {
        validateEmail()
        validatePassword()

        guard emailError == nil, passwordError == nil else {
            return false
        }

        return true
    }

    private func validateField(value: String, type: TextFieldType) -> Bool {
        let testValue = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return testValue.evaluate(with: value)
    }

    public func validateEmail() {
        resetEmailError()
        if email.isEmpty {
            emailError = .emptyEmail
        } else if !validateField(value: email, type: .email) {
            emailError = .invalidEmail
        }
    }

    public func validatePassword() {
        resetPasswordError()
        if password.isEmpty {
            passwordError = .emptyPassword
        } else if !validateField(value: password, type: .password) {
            passwordError = .invalidPassword
        }
    }

    public func resetLoginViewModel() {
        email = ""
        password = ""
        resetEmailError()
        resetPasswordError()
    }

    public func resetEmailError() {
        emailError = nil
    }

    public func resetPasswordError() {
        passwordError = nil
    }

    public func resetErrors() {
        resetEmailError()
        resetPasswordError()
    }

    public func signIn(_ completion: @escaping (Result<String, Error>) -> Void) {
        authService.signIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let result):
                if let result = result {
                    let userId = result.user.uid
                    completion(.success(userId))
                    self.analyticsManager.logEvent(event: .loginSucceded(userId: userId))
                } else {
                    self.analyticsManager.logEvent(event: .loginFailed)
                }
            case .failure(_):
                self.emailError = .invalidEmail
                self.passwordError = .invalidPassword
            }
        }
    }

    public func signOut(_ completion: @escaping (Result<String, Error>) -> Void) {
        authService.signOut { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
