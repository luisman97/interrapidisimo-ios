//
//  LocalitiesFactory.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import SwiftUI

enum LocalitiesFactory {
    static func getLocalitiesView() -> some View {
        let httpClient = HTTPClient()
        let repository = LocalitiesRepository(httpClient: httpClient)
        let useCase = FetchLocalitiesUseCase(repository: repository)
        let viewModel = LocalitiesViewModel(useCase: useCase)
        return LocalitiesView(viewModel: viewModel)
    }
}
