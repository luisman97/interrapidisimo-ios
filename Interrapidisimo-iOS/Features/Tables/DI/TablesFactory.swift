//
//  TablesFactory.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

enum TablesFactory {
    @ViewBuilder
    static func getTablesView(session: UserSession) -> some View {
        switch Result(catching: { try AppDatabase() }) {
        case .success(let appDatabase):
            let remoteRepository = TablesRepository(httpClient: HTTPClient())
            let localRepository = SQLiteTablesRepository(dbQueue: appDatabase.dbQueue)
            let useCase = FetchTablesUseCase(
                remoteRepository: remoteRepository,
                localRepository: localRepository
            )
            let viewModel = TablesViewModel(
                useCase: useCase,
                username: session.username
            )
            TablesView(viewModel: viewModel)
        case .failure:
            ContentUnavailableView(
                "Error de base de datos",
                systemImage: "externaldrive.badge.exclamationmark",
                description: Text("No se pudo inicializar la base de datos local.")
            )
        }
    }
}
