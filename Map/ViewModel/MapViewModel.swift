//
//  MapViewModel.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 11.06.2024.
//

import Foundation
import Combine
import MapKit
import CoreLocation

protocol MapViewModelProtocol {
    func requestUserLocation()
}

class MapViewModel: NSObject, ObservableObject, MapViewModelProtocol {

    private var locationService: LocationService
    private let analyticsManager: FirebaseAnalyticsManager

    @Published public var region = MKCoordinateRegion(
        center: Constants.defaultCoordinates,
        span: Constants.span
    )
    @Published public var categories: [Category] = [
        Category(name: "other long category"),
        Category(name: "cafe"),
        Category(name: "hotel"),
        Category(name: "spa"),
        Category(name: "cinema")
    ]

    @Published private(set) var location: CLLocation?
    @Published private(set) var locationError: LocationError?

    @Published var isLandmarkShortDetailViewDisplayed = false
    @Published private(set) var landmarks = [Landmark]()
    @Published public var selectedLandmark: Landmark?

    @Published var shouldShowAlert: Bool = false

    public var alertModel: AlertModel

    override init() {
        locationService = LocationService()
        analyticsManager = .shared
        alertModel = AlertModel()
        super.init()
        locationService.delegate = self

        requestUserLocation()
    }

    public func search(for category: Category) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = category.name
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                self.landmarks = []
                return
            }

            DispatchQueue.main.async {
                let items = response.mapItems
                self.landmarks = items.isEmpty 
                ? []
                : response.mapItems.map { item in
                    Landmark(
                        name: item.name ?? "",
                        placemark: item.placemark,
                        coordinate: item.placemark.coordinate,
                        phoneNumber: item.phoneNumber ?? ""
                    )
                }
            }
            self.analyticsManager.logEvent(event: .searchRequest(foundedCount: response.mapItems.count))
        }
    }

    public func search(for coordinates: String) {
        guard coordinates.split(separator: ",").count == 2 else { return }

        let latitude = Double(coordinates.split(separator: ",")[0]) ?? Constants.defaultCoordinates.latitude
        let longitude = Double(coordinates.split(separator: ",")[1]) ?? Constants.defaultCoordinates.longitude

        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: latitude, longitude:longitude)) { (places, error) in
            guard error == nil else {
                self.setAlertInfo(title: Constants.errorTitle, description: Constants.errorDescription)
                return
            }

            if let clPlacemark = places?.first,
               let mkPlacemark = self.convertToMKPlacemark(clPlacemark: clPlacemark) {

                let mkMapItem = MKMapItem(placemark: mkPlacemark)
                self.selectedLandmark = Landmark(
                    name: mkMapItem.name ?? "",
                    placemark: mkPlacemark,
                    coordinate: mkPlacemark.coordinate,
                    phoneNumber: mkMapItem.phoneNumber ?? ""
                )

                self.setLocationInfo(location: mkPlacemark.location, locationError: nil)
            }
        }
    }

    func setSelectedLandmark(landmark: Landmark?) {
        selectedLandmark = landmark
        isLandmarkShortDetailViewDisplayed.toggle()

        guard let selectedLandmark = selectedLandmark else { return }
        region = MKCoordinateRegion(center: selectedLandmark.coordinate, span: Constants.span)
    }

    func requestUserLocation() {
        locationService.requestUserLocation()
    }

    private func convertToMKPlacemark(clPlacemark: CLPlacemark) -> MKPlacemark? {
        guard let location = clPlacemark.location else {
            return nil
        }

        let coordinate = location.coordinate
        let addressDictionary = clPlacemark.addressDictionary

        let mkPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as? [String: Any])

        return mkPlacemark
    }
}

extension MapViewModel: LocationServiceDelegate {
    func setLocationInfo(location: CLLocation?, locationError: LocationError?) {
        self.location = location
        self.locationError = locationError

        guard let location = location else { return }
        self.region = MKCoordinateRegion(center: location.coordinate, span: Constants.span)
    }
}

private extension MapViewModel {
    func setAlertInfo(title: String, description: String) {
        alertModel.title = title
        alertModel.description = description
        shouldShowAlert = true
    }
}


