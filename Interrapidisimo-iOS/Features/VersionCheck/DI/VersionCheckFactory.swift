//
//  VersionCheckFactory.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

enum VersionCheckFactory {

    static func getVersionCheckView<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        let httpClient = HTTPClient()
        let repository = VersionCheckRepository(httpClient: httpClient)
        let useCase = CheckVersionUseCase(repository: repository)
        let viewModel = VersionCheckViewModel(useCase: useCase)
        return VersionCheckView(
            viewModel: viewModel,
            content: content
        )
    }
}
