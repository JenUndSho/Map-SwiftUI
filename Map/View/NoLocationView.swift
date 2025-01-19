//
//  NoLocationView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 06.06.2024.
//

import SwiftUI

struct NoLocationView: View {
    var body: some View {
        VStack {
            Text("Cannot access your\n location")
                .font(.system(size: 24.0))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Spacer()
                .frame(height: 20)

            Text("Please accept location request or enable location updates in settings")
                .font(.caption)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .frame(width: 224)
        }
        .padding(.top, 189)

        Spacer()

    }
}

#Preview {
    NoLocationView()
}
