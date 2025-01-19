//
//  CustomViewModifiers.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 25.06.2024.
//

import SwiftUI

struct MapCategory: ViewModifier {
    let isSelectedCategory: Bool

    func body(content: Content) -> some View {
        content
            .frame(minWidth: 41, maxHeight: 29)
            .padding([.leading, .trailing])
            .font(.system(size: 12))
            .fontWeight(.medium)
            .background(isSelectedCategory ? Color.mapRed : .white)
            .foregroundStyle(isSelectedCategory ? .white : .black)
            .cornerRadius(8)
            .padding(.all, 10)
            .shadow(color: .gray, radius: 4)
    }
}

struct UserLocation: ViewModifier {
    let isUserCentering: Bool

    func body(content: Content) -> some View {
        content
            .labelStyle(.iconOnly)
            .frame(width: 44, height: 44)
            .background(.white)
            .cornerRadius(8)
            .shadow(color: .gray, radius: 4)
            .padding([.trailing, .bottom], 20)
            .font(.system(size: 16))
            .foregroundStyle(isUserCentering ? .blue : .black)
    }
}

struct LoginTextField: ViewModifier {
    let width: Double
    let contextType: UITextContentType

    func body(content: Content) -> some View {
        content
            .padding(.all, 10)
            .frame(width: width * 0.9)
            .background(.white)
            .cornerRadius(10)
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 0.5)
            )
            .shadow(color: .gray, radius: 5)
            .textContentType(contextType)
            .submitLabel(.done)
            .textInputAutocapitalization(.none)
            .autocorrectionDisabled()
    }
}

