//
//  LocationService.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 18.06.2024.
//

import Foundation
import MapKit

enum Constants {
    static let defaultLatitude = 37.331516
    static let defaultLongitude = -121.891054
    static let defaultCoordinates = CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude)
    static let defaultLocation = CLLocation(latitude: defaultLatitude, longitude: defaultLongitude)
    static let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    static let region = MKCoordinateRegion(center: Constants.defaultCoordinates, span: Constants.span)
    static let defaultString = "Default"
    static let errorTitle = "Hold up!"
    static let errorDescription = "Unfortunatelly, we encountered problem on our side. Please try again later."
}

protocol LocationServiceDelegate: AnyObject {
    func setLocationInfo(location: CLLocation?, locationError: LocationError?)
}

class LocationService: NSObject {

    weak var delegate: LocationServiceDelegate?
    private var locationManager: CLLocationManager?
    private let analyticsManager: FirebaseAnalyticsManager

    init(analyticsManager: FirebaseAnalyticsManager = .shared) {
        self.analyticsManager = analyticsManager
    }

    public func requestUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }

    private func verifyLocationPermissions() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            analyticsManager.logEvent(event: .locationPermissionRestricted)
            delegate?.setLocationInfo(location: nil, locationError: .unauthorized)
        case .authorizedAlways, .authorizedWhenInUse:
            guard let location = locationManager.location else {
                delegate?.setLocationInfo(location: Constants.defaultLocation, locationError: nil)
                return
            }
            analyticsManager.logEvent(event: .locationPermissionGranted)
            delegate?.setLocationInfo(location: location, locationError: nil)
        @unknown default:
            break
        }
    }

}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        verifyLocationPermissions()
    }
}
