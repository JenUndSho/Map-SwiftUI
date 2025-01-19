//
//  MapView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 11.06.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @State private var isUserCentering: Bool = false
    @Binding var selectedCategory: Category
    @State private var shouldShowLandmarkDetailView = false
    private let analyticsManager = FirebaseAnalyticsManager.shared
    private let deeplinkHandler = DeeplinkHandler.shared

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                map

                VStack(alignment: .trailing) {
                    interestCategories

                    Spacer()

                    userLocation

                    showLandmarkShortDetailViewIfNeeded()

                    showLandmarkDetailViewIfNeeded(geometry)
                }
                .zIndex(1.0)
                .ignoresSafeArea(.container)
            }

        }
    }

    var map: some View {
        Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, annotationItems: mapViewModel.landmarks) { landmark in
            MapAnnotation(coordinate: landmark.coordinate) {
                LandmarkAnnotation(isSelected: .constant(landmark == mapViewModel.selectedLandmark))
                    .opacity(landmark == mapViewModel.selectedLandmark ? 1 : (shouldShowLandmarkDetailView ? 0 : 1))
                    .onTapGesture {
                        mapViewModel.setSelectedLandmark(landmark: landmark)
                        isUserCentering = false
                    }
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation {
                shouldShowLandmarkDetailView = false
            }
        }
        .onAppear {
            analyticsManager.logEvent(event: .mapDisplayed)
        }
        .animation(.spring, value: UUID())
    }

    var interestCategories: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 10)
                    ForEach(mapViewModel.categories, id: \.id) {category in
                        Text(category.name)
                            .mapCategoryStyle(isSelectedCategory: selectedCategory == category)
                            .onTapGesture {
                                didTapInterestCategory(category: category)
                            }
                    }
                }
            }
            .padding(.top, 40)
            .onOpenURL { url in
                deeplinkHandler.openCategoryDeeplink(url: url) { parameterValue in
                    let category = mapViewModel.categories.filter({ $0.name == parameterValue }).first ?? Category(name: "")
                    if let _ = mapViewModel.categories.firstIndex(of: category) {
                        proxy.scrollTo(category.id)
                    }
                    didTapInterestCategory(category: category)
                }
            }
            .opacity(shouldShowLandmarkDetailView ? 0 : 1)
        }

    }

    var userLocation: some View {
        Label("Location user", systemImage: isUserCentering ? "location.fill" : "location")
            .userLocationStyle(isUserCentering: isUserCentering)
            .onTapGesture {
                analyticsManager.logEvent(event: .userCenteringButtonTapped)
                mapViewModel.requestUserLocation()
                withAnimation {
                    isUserCentering = true
                }
            }
    }

    @ViewBuilder
    private func showLandmarkShortDetailViewIfNeeded() -> some View {
        if mapViewModel.selectedLandmark != nil && !shouldShowLandmarkDetailView  {
            LandmarkShortDetailView(viewModel: LandmarkShortDetailViewModel(mapViewModel: mapViewModel))
                .shadow(color: .gray, radius: 4)
                .onTapGesture {
                    withAnimation {
                        shouldShowLandmarkDetailView = true
                    }
                }
        }
    }

    @ViewBuilder
    private func showLandmarkDetailViewIfNeeded(_ geometry: GeometryProxy) -> some View {
        LandmarkDetailView(viewModel: LandmarkDetailViewModel(mapViewModel: mapViewModel), isDisplayed: $shouldShowLandmarkDetailView, parentHeight: geometry.size.height)
            .transition(.move(edge: .bottom))
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    if value.translation.height > 0 {
                        withAnimation {
                            shouldShowLandmarkDetailView = false
                        }
                    }
                }
            )
    }

    private func didTapInterestCategory(category: Category) {
        analyticsManager.logEvent(event: .categoryButtonTapped(category: category.name))
        selectedCategory = category
        mapViewModel.search(for: category)
        mapViewModel.setSelectedLandmark(landmark: nil)
        withAnimation {
            shouldShowLandmarkDetailView = false
        }
    }
}

#Preview {
    MapView(mapViewModel: MapViewModel(), selectedCategory: .constant(Category(name: "")))
}
