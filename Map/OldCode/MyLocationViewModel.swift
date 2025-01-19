//
//  MyLocationViewModel.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 06.06.2024.
//

import Combine
import Foundation
import MapKit

enum LocationError: Error {
    case unauthorized
    case unableToDetermineLocation
}

class MyLocationViewModel: NSObject, ObservableObject {

    private var cancellables = Set<AnyCancellable>()
    private let locationService = LocationServiceOld()

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var location: CLLocation?
    @Published private(set) var locationError: LocationError?

    override init() {
        super.init()
    }

    public func fetchLocation() {
        isLoading = true

        locationService.requestWhenInUseAuthorization()
            .flatMap { self.locationService.requestLocation() }
            .sink { completion in
                if case .failure(let error) = completion {
                    self.locationError = error
                }
                self.isLoading = false
            } receiveValue: { location in
                self.location = location
            }
            .store(in: &cancellables)
    }
}
