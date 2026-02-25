//
//  VersionCheckViewModel.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

@Observable
final class VersionCheckViewModel {
    var versionStatus: VersionStatus = .upToDate
    var isLoading = false
    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""

    private let useCase: CheckVersionUseCaseProtocol

    init(useCase: CheckVersionUseCaseProtocol) {
        self.useCase = useCase
    }

    func checkVersion() async {
        isLoading = true
        defer { isLoading = false }

        do {
            versionStatus = try await useCase.execute()
            applyAlert(for: versionStatus)
        } catch {
            
        }
    }

    private func applyAlert(for status: VersionStatus) {
        switch status {
        case .upToDate:
            showAlert = false

        case .updateAvailable(let version):
            alertTitle   = "Nueva Versión Disponible"
            alertMessage = "Hay una nueva versión (\(version)) disponible. Te recomendamos actualizar."
            showAlert    = true

        case .versionAhead(let version):
            alertTitle   = "Versión Superior Detectada"
            alertMessage = "La versión instalada es superior a la remota (\(version)). Ambiente inconsistente."
            showAlert    = true
        }
    }
}
