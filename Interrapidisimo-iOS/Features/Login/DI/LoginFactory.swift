//
//  LoginFactory.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

enum LoginFactory {
    @ViewBuilder
    static func getLoginView(onSuccess: @escaping (UserSession) -> Void) -> some View {
        switch Result(catching: { try AppDatabase() }) {
        case .success(let appDatabase):
            let loginRepository = LoginRepository(httpClient: HTTPClient())
            let sessionRepository = SQLiteUserSessionRepository(dbQueue: appDatabase.dbQueue)
            let useCase = LoginUseCase(
                loginRepository: loginRepository,
                sessionRepository: sessionRepository
            )
            let viewModel = LoginViewModel(useCase: useCase)
            LoginView(viewModel: viewModel, onSuccess: onSuccess)
        case .failure:
            ContentUnavailableView(
                "Error de base de datos",
                systemImage: "externaldrive.badge.exclamationmark",
                description: Text("No se pudo inicializar la base de datos local.")
            )
        }
    }
}
