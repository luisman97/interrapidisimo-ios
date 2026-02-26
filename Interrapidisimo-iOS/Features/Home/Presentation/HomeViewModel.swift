//
//  HomeViewModel.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

@Observable
final class HomeViewModel {
    let session: UserSession

    init(session: UserSession) {
        self.session = session
    }
}
