//
//  LandmarkAnnotation.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 19.06.2024.
//

import SwiftUI

struct LandmarkAnnotation: View {
    
    @Binding var isSelected: Bool

    private var externalSize: CGFloat {
        isSelected ? 40 : 21
    }

    private var innerSize: CGFloat {
        isSelected ? 29 : 15
    }

    var body: some View {
        Circle()
            .strokeBorder(Color.mapRedLight, lineWidth: 2)
            .foregroundStyle(Color.clear)
            .frame(width: externalSize, height: externalSize)
            .overlay(Circle()
                .foregroundStyle(Color.mapRed)
                .frame(width: innerSize, height: innerSize)
            )
    }
}

#Preview {
    LandmarkAnnotation(isSelected: .constant(true))
}
