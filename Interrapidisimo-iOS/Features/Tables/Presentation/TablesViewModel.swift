//
//  TablesViewModel.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

@Observable
final class TablesViewModel {
    var state: TablesViewState = .loading

    private let useCase: FetchTablesUseCaseProtocol
    private let username: String

    init(
        useCase: FetchTablesUseCaseProtocol,
        username: String
    ) {
        self.useCase = useCase
        self.username = username
    }

    func fetchTables() async {
        state = .loading
        do {
            let schemas = try await useCase.execute(username: username)
            state = .loaded(schemas)
        } catch let error as NetworkError {
            state = .failed(error.localizedDescription)
        } catch {
            state = .failed("Error inesperado al cargar tablas.")
        }
    }
}
