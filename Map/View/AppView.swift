//
//  AppView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 05.06.2024.
//

import SwiftUI

struct AppView: View {

    @StateObject private var mapViewModel = MapViewModel()
    @State private var selectedCategory = Category(name: "")
    private let deeplinkHandler = DeeplinkHandler.shared

    var body: some View {
        if let _ = mapViewModel.location {
            MapView(mapViewModel: mapViewModel, selectedCategory: $selectedCategory)
                .onOpenURL { url in
                    deeplinkHandler.openPlacesDeeplink(url: url) { parameterValue in
                        mapViewModel.search(for: parameterValue)
                        selectedCategory = .init(name: "")
                    }
                }
        } else if let _ = mapViewModel.locationError {
            NoLocationView()
        }

//        MapView(mapViewModel: mapViewModel, selectedCategory: $selectedCategory)
//            .onOpenURL { url in
//                deeplinkHandler.openPlacesDeeplink(url: url) { parameterValue in
//                    mapViewModel.search(for: parameterValue)
//                    selectedCategory = .init(name: "")
//                }
//            }
    }
}

#Preview {
    AppView()
}
