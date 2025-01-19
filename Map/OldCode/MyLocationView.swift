//
//  MyLocationView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 06.06.2024.
//

import Foundation
import SwiftUI

struct MyLocationView: View {
    @StateObject var viewModel = MyLocationViewModel()

    var body: some View {
        VStack {
            Button("Get my location") {
                viewModel.fetchLocation()
            }
            .disabled(viewModel.isLoading)
            if viewModel.isLoading {
                ProgressView()
            } else if let location = viewModel.location {
                Text(location.description)
            } else if let error = viewModel.locationError {
                Text(error.localizedDescription)
            }
        }
    }
}

#Preview {
    MyLocationView()
}
