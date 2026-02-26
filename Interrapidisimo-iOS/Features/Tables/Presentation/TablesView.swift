//
//  TablesView.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

struct TablesView: View {
    @State var viewModel: TablesViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let schemas):
                List(schemas, id: \.tableName) { schema in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(schema.tableName)
                            .font(.headline)
                        Text("PK: \(schema.pk) · \(schema.fieldCount) campos")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            case .failed(let message):
                ContentUnavailableView(
                    "Error al cargar tablas",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            }
        }
        .navigationTitle("Tablas")
        .task { await viewModel.fetchTables() }
    }
}
