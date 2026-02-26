//
//  HomeView.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    let onLogout: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Datos de sesión", systemImage: "person.crop.circle.badge.checkmark")
                            .font(.headline)
                            .padding(.bottom, 4)

                        infoRow(
                            title: "Usuario",
                            value: viewModel.session.username,
                            systemImage: "person"
                        )
                        infoRow(
                            title: "Identificación",
                            value: viewModel.session.documentId ?? "—",
                            systemImage: "creditcard"
                        )
                        infoRow(
                            title: "Nombre",
                            value: viewModel.session.name ?? "—",
                            systemImage: "person.text.rectangle"
                        )
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

                    HStack(spacing: 16) {
                        NavigationLink {
                            TablesFactory.getTablesView(session: viewModel.session)
                        } label: {
                            Label("Tablas", systemImage: "square.3.layers.3d")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)

                        NavigationLink {
                            LocalitiesFactory.getLocalitiesView()
                        } label: {
                            Label("Localidades", systemImage: "map")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Inicio")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onLogout()
                    } label: {
                        Label("Salir", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .tint(.orange)
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension HomeView {
    func infoRow(
        title: String,
        value: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
                .frame(width: 18)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
    }
}
