//
//  LoginView.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    let onSuccess: (UserSession) -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.48),
                    Color.white,
                    Color.interBlue.opacity(0.42)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Image(systemName: "shippingbox.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.orange, .interBlue)

                    Text("Interrapidisimo")
                        .font(.title2.bold())
                    Text("Inicia sesión para continuar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 14) {
                    inputField(
                        title: "Usuario",
                        icon: "person.crop.circle",
                        text: $viewModel.username
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                    secureInputField(
                        title: "Contraseña",
                        icon: "lock.circle",
                        text: $viewModel.password
                    )
                }

                Button {
                    Task { await viewModel.login() }
                } label: {
                    Label("Ingresar", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.orange)
                .disabled(viewModel.state == .loading)
            }
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onChange(of: viewModel.state) { _, newState in
            if newState == .success, let session = viewModel.session {
                onSuccess(session)
            }
        }
        .alert(
            "Error de autenticación",
            isPresented: .constant(errorMessage != nil)
        ) {
            Button("Aceptar", role: .cancel) {
                viewModel.state = .idle
            }
        } message: {
            Text(errorMessage ?? "")
        }
        .overlay {
            if viewModel.state == .loading {
                ProgressView()
            }
        }
    }
}

// MARK: - Private Computed Properties

private extension LoginView {
    var errorMessage: String? {
        if case .failed(let message) = viewModel.state { return message }
        return nil
    }
}

// MARK: - Private Methods

private extension LoginView {
    func inputField(
        title: String,
        icon: String,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 18)
            TextField(
                title,
                text: text
            )
        }
        .padding(.horizontal, 12)
        .frame(height: 46)
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.quaternary)
        }
    }

    func secureInputField(
        title: String,
        icon: String,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 18)
            SecureField(
                title,
                text: text
            )
        }
        .padding(.horizontal, 12)
        .frame(height: 46)
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.quaternary)
        }
    }
}
