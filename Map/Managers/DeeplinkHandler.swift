//
//  DeeplinkHandler.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 14.07.2024.
//

import Foundation

class DeeplinkHandler {

    public static let shared: DeeplinkHandler = DeeplinkHandler()

    private init() { }

    private func openDeepLink(url: URL,
                              host: String,
                              parameterName: String,
                              _ completion: @escaping (String) -> Void) {
        guard let scheme = url.scheme,
              scheme.lowercased() == Constants.scheme.lowercased(),
              url.host == host,
              let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else {
            return
        }

        if queryItems[0].name == parameterName {
            completion(queryItems[0].value ?? "")
        }
    }

    public func openPlacesDeeplink(url: URL, _ completion: @escaping (String) -> Void) {
        openDeepLink(url: url,
                     host: Constants.placesHost,
                     parameterName: Constants.id,
                     completion)
    }

    public func openCategoryDeeplink(url: URL, _ completion: @escaping (String) -> Void) {
        openDeepLink(url: url,
                     host: Constants.mapHost,
                     parameterName: Constants.category,
                     completion)
    }

}

private extension DeeplinkHandler {
    enum Constants {
        static let scheme = "mapApp"
        static let placesHost = "places"
        static let mapHost = "map"
        static let id = "id"
        static let category = "category"
    }
}
