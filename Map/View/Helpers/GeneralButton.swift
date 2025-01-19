//
//  GeneralButton.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 16.06.2024.
//

import SwiftUI

struct GeneralButton: View {

    var text: String
    var height: Double
    var width: Double = .infinity
    var action: (() -> Void)

    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Text(text)
                    .padding()
                    .frame(maxWidth: width)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .frame(height: height)
            }
            .background(Color.mapRed)
            .cornerRadius(16)
        }
        .animation(.spring, value: UUID())

    }
}

#Preview {
    GeneralButton(text: "My Text", height: 47) {
        print("Tapped")
    }
}
