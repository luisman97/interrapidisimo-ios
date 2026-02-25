//
//  VersionCheckView.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

struct VersionCheckView<Content: View>: View {
    @State var viewModel: VersionCheckViewModel
    @Environment(\.openURL) private var openURL
    private let content: Content

    init(
        viewModel: VersionCheckViewModel,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content()
    }

    var body: some View {
        content
            .task { await viewModel.checkVersion() }
            .alert(
                viewModel.alertTitle,
                isPresented: $viewModel.showAlert
            ) {
                alertActions
            } message: {
                Text(viewModel.alertMessage)
            }
    }

    @ViewBuilder
    private var alertActions: some View {
        switch viewModel.versionStatus {
        case .updateAvailable:
            Button("Ir al App Store") {
                guard let url = URL.appStore else { return }
                openURL(url)
            }
            Button("Después", role: .cancel) {}
        default:
            Button("Entendido", role: .cancel) {}
        }
    }
}
