//
//  Interrapidisimo_iOSApp.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI

@main
struct Interrapidisimo_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            VersionCheckFactory.getVersionCheckView {
                Text("Home")
            }
        }
    }
}
