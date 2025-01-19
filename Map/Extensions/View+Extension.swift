//
//  View+Extension.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 25.06.2024.
//

import Foundation
import SwiftUI

extension View {
    func mapCategoryStyle(isSelectedCategory: Bool) -> some View {
        modifier(MapCategory(isSelectedCategory: isSelectedCategory))
    }

    func userLocationStyle(isUserCentering: Bool) -> some View {
        modifier(UserLocation(isUserCentering: isUserCentering))
    }

    func loginTextFieldStyle(width: Double, contextType: UITextContentType) -> some View {
        modifier(LoginTextField(width: width, contextType: contextType))
    }
}
