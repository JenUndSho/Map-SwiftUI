//
//  LoginView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 13.06.2024.
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel

    @Binding var userId: String?
    @Binding var isDisplayed: Bool
    @Binding var isLoggedIn: Bool
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool

    var body: some View {
        if isDisplayed {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                content(screenWidth)
            }
        }
    }

    @ViewBuilder
    private func content(_ width: Double) -> some View {
        VStack {
            Text("Please login to save \nlocations")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 50)

            Spacer()
                .frame(height: 30)

            TextField("Enter Name", text: $loginViewModel.email)
                .loginTextFieldStyle(width: width, contextType: .emailAddress)
                .onSubmit {
                    loginViewModel.validateEmail()
                    print("do nothing ON SUBMIT")
                }
                .focused($isEmailFocused)

            if let emailError = loginViewModel.emailError {
                errorLabel(emailError)
            }

            Spacer()
                .frame(height: 20)

            SecureInputView("Password", text: $loginViewModel.password)
                .loginTextFieldStyle(width: width, contextType: .password)
                .onSubmit {
                    loginViewModel.validatePassword()
                    print("do nothing ON SUBMIT")
                }
                .onReceive(Just(loginViewModel.password)) { _ in
                    if loginViewModel.password.count > 25 {
                        loginViewModel.password = String(loginViewModel.password.prefix(25))
                    }
                }

            if let passwordError = loginViewModel.passwordError {
                errorLabel(passwordError)
            }

            Spacer()
                .frame(height: 20)

            GeneralButton(text: "Login", height: 47) {
                guard loginViewModel.isValidInput else { return }

                loginViewModel.signIn() { result in
                    switch result {
                    case .success(let userId):
                        self.userId = userId
                        withAnimation {
                            isDisplayed = false
                            isLoggedIn = true
                        }
                        loginViewModel.resetLoginViewModel()
                    case .failure:
                        print("Error")
                    }
                }
            }

            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .padding([.leading, .trailing], 20)
        .background(.white)
        .clipShape(
            .rect(
            topLeadingRadius: 16,
            topTrailingRadius: 16
            )
        )
    }

    @ViewBuilder
    private func errorLabel(_ error: TextFieldError) -> some View {
        HStack {
            Text(error.description)
                .frame(alignment: .leading)
                .font(.system(size: 16))
                .fontWeight(.semibold)
            .foregroundStyle(Color.mapRed)

            Spacer()
        }
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel(), userId: .constant(""), isDisplayed: .constant(true), isLoggedIn: .constant(true))
}
