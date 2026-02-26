//
//  LocalitiesView.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import SwiftUI

struct LocalitiesView: View {
    @State var viewModel: LocalitiesViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let localities):
                List(localities, id: \.localityId) { locality in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(locality.cityAbbreviation)
                            .font(.headline)
                        Text(locality.fullName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            case .failed(let message):
                ContentUnavailableView(
                    "Error al cargar localidades",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            }
        }
        .navigationTitle("Localidades")
        .task { await viewModel.fetchLocalities() }
    }
}
