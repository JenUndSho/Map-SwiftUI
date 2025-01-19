//
//  FirebaseAnalyticsManager.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 10.07.2024.
//

import Foundation
import Firebase

enum AnalyticsEvent {
    case locationPermissionGranted
    case locationPermissionRestricted
    case mapDisplayed
    case categoryButtonTapped(category: String)
    case viewOnMapButtonTapped(latitude: Double, longitude: Double)
    case searchRequest(foundedCount: Int)
    case userCenteringButtonTapped
    case addToFavoritesButtonTapped(placeId: String)
    case removeFromFavoritesButtonTapped(placeId: String)
    case loginSucceded(userId: String)
    case loginFailed
    case logoutSucceded
    case logoutFailed

    var name: String {
        switch self {
        case .locationPermissionGranted:
            return "location_permission_granted"
        case .locationPermissionRestricted:
            return "location_permission_restricted"
        case .mapDisplayed:
            return "map_displayed"
        case .categoryButtonTapped:
            return "category_button_tapped"
        case .viewOnMapButtonTapped:
            return "view_on_map_button_tapped"
        case .searchRequest:
            return "search_request"
        case .userCenteringButtonTapped:
            return "user_centering_button_tapped"
        case .addToFavoritesButtonTapped:
            return "add_to_favorites_button_tapped"
        case .removeFromFavoritesButtonTapped:
            return "remove_from_favorites_button_tapped"
        case .loginSucceded:
            return "login_succeded"
        case .loginFailed:
            return "login_failed"
        case .logoutSucceded:
            return "logout_succeded"
        case .logoutFailed:
            return "logout_failed"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .categoryButtonTapped(let category):
            return ["category": category]
        case .viewOnMapButtonTapped(let latitude, let longitude):
            return [
                "latitude": latitude,
                "longitude": longitude
            ]
        case .searchRequest(let foundedCount):
            return ["foundedCount": foundedCount]
        case .addToFavoritesButtonTapped(let placeId):
            return ["placeId": placeId]
        case .removeFromFavoritesButtonTapped(let placeId):
            return ["placeId": placeId]
        case .loginSucceded(let userId):
            return ["userId": userId]
        default:
            return nil
        }
    }
}

class FirebaseAnalyticsManager {

    public static let shared: FirebaseAnalyticsManager = FirebaseAnalyticsManager()

    private init() { }

    public func logEvent(event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }

}
