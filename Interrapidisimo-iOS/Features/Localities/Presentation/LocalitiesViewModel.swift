//
//  LocalitiesViewModel.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import SwiftUI

@Observable
final class LocalitiesViewModel {
    var state: LocalitiesViewState = .loading

    private let useCase: FetchLocalitiesUseCaseProtocol

    init(useCase: FetchLocalitiesUseCaseProtocol) {
        self.useCase = useCase
    }

    func fetchLocalities() async {
        state = .loading
        do {
            let localities = try await useCase.execute()
            state = .loaded(localities)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
