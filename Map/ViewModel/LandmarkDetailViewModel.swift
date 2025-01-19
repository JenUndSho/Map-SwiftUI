//
//  LandmarkDetailViewModel.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 08.07.2024.
//

import Foundation

class LandmarkDetailViewModel: ObservableObject {

    public var selectedLandmark: Landmark?
    private let dbService: FirebaseRealtimeDBService
    private let analyticsManager: FirebaseAnalyticsManager

    @Published private var isFavorite: Bool = false

    init(mapViewModel: MapViewModel,
         analyticsManager: FirebaseAnalyticsManager = .shared) {
        self.selectedLandmark = mapViewModel.selectedLandmark
        dbService = FirebaseRealtimeDBService()
        self.analyticsManager = analyticsManager
    }

    public func isSelectedLandmarkFavorite(for userId: String) -> Bool {
        guard let selectedLandmark = selectedLandmark else {
                return false
        }
        
        dbService.readFavorites(for: userId) { array in
            self.isFavorite = array.contains(selectedLandmark.identifier)
        }

        return isFavorite

    }

    public func toggleToFavorites(for userId: String?) {
        guard let userId = userId, let selectedLandmark = selectedLandmark else {
                return
        }

        if isFavorite {
            removeFromFavorites(for: userId, place: selectedLandmark.identifier)
        } else {
            addToFavorites(for: userId, place: selectedLandmark.identifier)
        }
    }

    private func addToFavorites(for userId: String, place: String) {
        analyticsManager.logEvent(event: .addToFavoritesButtonTapped(placeId: place))
        dbService.addToFavorites(for: userId, place: place)
        isFavorite = true
    }

    private func removeFromFavorites(for userId: String, place: String) {
        analyticsManager.logEvent(event: .removeFromFavoritesButtonTapped(placeId: place))
        dbService.removeFromFavorites(for: userId, place: place)
        isFavorite = false
    }

    public var landmarkAddress: String {
        guard let selectedLandmark = selectedLandmark else {
            return ""
        }
        let thoroughfare = selectedLandmark.placemark.thoroughfare ?? ""
        let subThoroughfare = selectedLandmark.placemark.subThoroughfare ?? ""

        if !thoroughfare.isEmpty && subThoroughfare.isEmpty {
            return thoroughfare
        } else if thoroughfare.isEmpty && !subThoroughfare.isEmpty {
            return subThoroughfare
        } else if thoroughfare.isEmpty && subThoroughfare.isEmpty {
            return ""
        }

        return "\(thoroughfare), \(subThoroughfare)"
    }

    public var name: String {
        return selectedLandmark?.name ?? Constants.defaultString
    }

    public var phoneNumber: String {
        return selectedLandmark?.phoneNumber ?? Constants.defaultString
    }
}
