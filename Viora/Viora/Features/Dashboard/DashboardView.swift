//
//  DashboardView.swift
//  Viora
//
//  Created by tascu nicoleta on 01/08/2026.
//

import SwiftUI

struct DashboardView: View {
    @State private var viewModel: DashboardViewModel = .init()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text(viewModel.greetingWithName)
                    .font(.headline)
                    .foregroundStyle(.gray600.opacity(0.7))
                
                StatisticsRowView(
                    tasksCount: 0,
                    habitsCount: 0,
                    expensesToday: 0
                )
                EmptyTaskView(
                    onAddTask: {}
                )
                QuickActionsView()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .background(.purpleApp.opacity(0.05))
    }
}

#Preview {
    DashboardView()
}
