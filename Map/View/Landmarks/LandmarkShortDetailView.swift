//
//  LandmarkShortDetailView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 17.06.2024.
//

import SwiftUI

struct LandmarkShortDetailView: View {
    @ObservedObject var viewModel: LandmarkShortDetailViewModel

    var body: some View {
        VStack {
            content
                .frame(height: 44)
                .frame(maxWidth: .infinity)
        }
        .padding([.leading, .trailing], 19)
        .padding([.bottom, .top], 30)
        .background(.white)
        .cornerRadius(16)
        .padding([.leading, .bottom, .trailing], 20)
    }

    var content: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 24))
                    .fontWeight(.bold)

                Spacer()

                Text(phoneNumber)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()
                .frame(width: 20)

            GeneralButton(text: "View on Map", height: 44) {
                viewModel.openMap()
                print("View on map")
            }
            .frame(height: 44, alignment: .leading)
            .fixedSize()
        }
    }
}

extension LandmarkShortDetailView {
    private var name: String {
        return viewModel.selectedLandmark?.name ?? Constants.defaultString
    }

    private var phoneNumber: String {
        return viewModel.selectedLandmark?.phoneNumber ?? Constants.defaultString
    }
}

#Preview {
    LandmarkShortDetailView(viewModel: LandmarkShortDetailViewModel(mapViewModel: MapViewModel()))
}
