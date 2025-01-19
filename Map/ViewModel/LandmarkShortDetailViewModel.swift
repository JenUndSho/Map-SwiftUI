//
//  LandmarkShortDetailViewModel.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 05.07.2024.
//

import Foundation
import MapKit

class LandmarkShortDetailViewModel: ObservableObject {

    public var selectedLandmark: Landmark?
    private let analyticsManager: FirebaseAnalyticsManager

    init(mapViewModel: MapViewModel,
         analyticsManager: FirebaseAnalyticsManager = .shared) {
        self.selectedLandmark = mapViewModel.selectedLandmark
        self.analyticsManager = analyticsManager
    }

    public func openMap() {
        guard let selectedLandmark = selectedLandmark else { return }
        analyticsManager.logEvent(event: .viewOnMapButtonTapped(latitude: selectedLandmark.coordinate.latitude, longitude: selectedLandmark.coordinate.longitude))
        let item = MKMapItem(placemark: MKPlacemark(coordinate: selectedLandmark.coordinate))
        item.openInMaps()
    }
}
