//
//  AppTabView.swift
//  Viora
//
//  Created by tascu nicoleta on 01/08/2026.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text(String(localized: "home_tab", defaultValue: "Home"))
                }
            TasksView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(String(localized: "tasks_tab", defaultValue: "Tasks"))
                }
        }
        .tint(.purpleApp)
    }
}

#Preview {
    AppTabView()
}
