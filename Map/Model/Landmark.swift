//
//  Landmark.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 18.06.2024.
//

import Foundation
import MapKit

struct Landmark: Identifiable {
    let id = UUID()
    let name: String
    let placemark: MKPlacemark
    let coordinate: CLLocationCoordinate2D
    let phoneNumber: String

    var identifier: String {
        guard let identifier = placemark.region?.identifier,
              let lastIndex = identifier.firstIndex(of: ">")
        else { return  "" }
        let firstIndex = identifier.index(identifier.startIndex, offsetBy: 1)
        return String(identifier[firstIndex..<lastIndex])
    }
}

extension Landmark: Equatable {
    static func ==(lhs: Landmark, rhs: Landmark) -> Bool {
        return lhs.id == rhs.id
    }
}
