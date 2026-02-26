//
//  LoginViewModel.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

@Observable
final class LoginViewModel {
    var state: LoginViewState = .idle
    private(set) var session: UserSession?
    var username: String = "pam.meredy21"
    var documentId: String = "987204545"
    var serviceOfficeId: String = "1295"
    var serviceOfficeName: String = "PTO/BOGOTA/CUND/COL/OF PRINCIPAL - CRA 30 # 7-45"
    var password: String = "Inter2021"

    private let useCase: LoginUseCaseProtocol

    init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }

    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            state = .failed("Ingresa usuario y contraseña para continuar.")
            return
        }

        state = .loading

        let credentials = LoginCredentials(
            username: username,
            documentId: documentId,
            serviceOfficeId: serviceOfficeId,
            serviceOfficeName: serviceOfficeName,
            password: password
        )

        do {
            session = try await useCase.execute(credentials: credentials)
            state = .success
        } catch let error as NetworkError {
            state = .failed(error.localizedDescription)
        } catch {
            state = .failed("Error inesperado. Intenta de nuevo.")
        }
    }
}
