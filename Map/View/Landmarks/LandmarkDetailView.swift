//
//  LandmarkDetailView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 14.06.2024.
//

import SwiftUI

struct LandmarkDetailView: View {

    @ObservedObject var viewModel: LandmarkDetailViewModel
    @StateObject var loginViewModel = LoginViewModel()
    @GestureState private var translation: CGFloat = 0
    @Binding var isDisplayed: Bool
    @State private var shouldShowLoginView = false
    @State private var isLoggedIn = false

    var parentHeight: CGFloat

    @State var currentHeight: CGFloat = 0
    @State var userId: String?

    var body: some View {
        ZStack() {
            if isDisplayed {
                content
            }
        }
        .overlay {
            loginSheet
        }
    }

    var buttonText: String {
        if !isLoggedIn {
            return "Login"
        } else if !isFavorite {
            return "Save address"
        } else {
            return "Remove address"
        }
    }

    var logOutBtb: some View {
        Label("Log Out button", systemImage: "rectangle.portrait.and.arrow.right")
            .labelStyle(.iconOnly)
            .foregroundStyle(.black)
            .font(.system(size: 20))
            .onTapGesture {
                withAnimation {
                    loginViewModel.signOut { result in
                        switch result {
                        case .success(_):
                            isLoggedIn = false
                            userId = nil
                        case .failure(let failure):
                            print(failure)
                        }
                    }

                }
            }
    }

    var content: some View {
        VStack {
            HStack {
                Text(viewModel.name)
                    .font(.system(size: 24))
                    .fontWeight(.bold)

                Spacer()

                Label("Toggle Favorites", systemImage: isFavorite ? "star.fill" : "star")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(isFavorite ? .yellow : .gray)
                    .font(.system(size: 30))
                    .padding(.bottom, 4)
            }
            .padding(.bottom, 4)

            HStack {
                VStack {
                    Text(viewModel.phoneNumber)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(.bottom, 2)

                    Text(viewModel.landmarkAddress)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if isLoggedIn {
                    logOutBtb
                }
            }

            Divider()
                .padding(.bottom, 4)

            GeneralButton(text: buttonText, height: 47) {

                if isLoggedIn {
                    viewModel.toggleToFavorites(for: userId)
                } else {
                    withAnimation {
                        shouldShowLoginView = true
                    }
                }
            }
            .padding([.leading, .trailing], 4)
        }
        .padding(.all, 20)
        .background(.white)
        .clipShape(
            .rect(
                topLeadingRadius: 16,
                topTrailingRadius: 16
            )
        )
        .transition(.move(edge: .bottom))
    }

    var loginSheet: some View {
        LoginView(loginViewModel: loginViewModel, userId: $userId, isDisplayed: $shouldShowLoginView, isLoggedIn: $isLoggedIn)
            .frame(minHeight: parentHeight * 1.6)
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        withAnimation {
                            loginViewModel.resetLoginViewModel()
                            shouldShowLoginView = false
                        }
                    }
                }
            )
    }
}

extension LandmarkDetailView {
//    private var landmarkAddress: String {
//        guard let selectedLandmark = viewModel.selectedLandmark else {
//            return ""
//        }
//        let thoroughfare = selectedLandmark.placemark.thoroughfare ?? ""
//        let subThoroughfare = selectedLandmark.placemark.subThoroughfare ?? ""
//
//        if !thoroughfare.isEmpty && subThoroughfare.isEmpty {
//            return thoroughfare
//        } else if thoroughfare.isEmpty && !subThoroughfare.isEmpty {
//            return subThoroughfare
//        } else if thoroughfare.isEmpty && subThoroughfare.isEmpty {
//            return ""
//        }
//
//        return "\(thoroughfare), \(subThoroughfare)"
//    }
//
//    private var name: String {
//        return viewModel.selectedLandmark?.name ?? Constants.defaultString
//    }
//
//    private var phoneNumber: String {
//        return viewModel.selectedLandmark?.phoneNumber ?? Constants.defaultString
//    }

    private var isFavorite: Bool {
        guard let userId = userId else { return false }
        return viewModel.isSelectedLandmarkFavorite(for: userId)
    }
}

#Preview {
    LandmarkDetailView(viewModel: LandmarkDetailViewModel(mapViewModel: MapViewModel()), isDisplayed: .constant(true), parentHeight: 0.0)
}
