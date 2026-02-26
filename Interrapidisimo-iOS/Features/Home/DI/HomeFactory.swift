//
//  HomeFactory.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

enum HomeFactory {
    static func getHomeView(
        session: UserSession,
        onLogout: @escaping () -> Void
    ) -> some View {
        let viewModel = HomeViewModel(session: session)
        return HomeView(
            viewModel: viewModel,
            onLogout: onLogout
        )
    }
}
