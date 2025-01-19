//
//  MapView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 10.06.2024.
//

import Foundation

import SwiftUI
import MapKit

struct MapViewTest: View {
    var coordinate: CLLocationCoordinate2D
    @ObservedObject var viewModel = MyLocationViewModel()

    var body: some View {
        Map(coordinateRegion: .constant(region), showsUserLocation: true, userTrackingMode: .constant(.follow))
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
}

#Preview {
    MapViewTest(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
}
