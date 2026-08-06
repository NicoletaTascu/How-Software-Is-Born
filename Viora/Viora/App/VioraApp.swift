//
//  VioraApp.swift
//  Viora
//
//  Created by tascu nicoleta on 01/08/2026.
//

import SwiftUI

@main
struct VioraApp: App {
    private let appContainer = AppContainer()

    var body: some Scene {
        WindowGroup {
            AppTabView(appContainer: appContainer)
        }
    }
}
