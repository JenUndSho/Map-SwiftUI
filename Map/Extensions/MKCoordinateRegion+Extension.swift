//
//  MKCoordinateRegion+Extension.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 03.07.2024.
//

import Foundation
import MapKit

extension MKCoordinateRegion: Equatable {
    public static func ==(lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center.latitude == rhs.center.latitude &&
            lhs.center.longitude == rhs.center.longitude
    }
}
