//
//  StatisticsRowView.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

struct StatisticsRowView: View {
    let tasksCount: Int
    let habitsCount: Int
    let expensesToday: Double
    
    var body: some View {
        HStack(spacing: 10) {
            StatisticItemView(
                icon: "checkmark.circle",
                iconColor: .purpleApp,
                value: "\(tasksCount)",
                label: "task",
                sublabel: "today"
            )
            
            Rectangle()
                .fill(.purpleApp.opacity(0.2))
                .frame(width: 1)

            StatisticItemView(
                icon: "flame.fill",
                iconColor: .orangeApp,
                value: "\(habitsCount)",
                label: "habits",
                sublabel: "today",
                labelColor: .orangeApp
            )
            
            Rectangle()
                .fill(.purpleApp.opacity(0.2))
                .frame(width: 1)

            StatisticItemView(
                icon: "creditcard",
                iconColor: .blueApp,
                value: "\(Int(expensesToday))",
                label: "expenses",
                sublabel: "today",
                labelColor: .blueApp,
                withCurrency: true
            )
        }
        .padding(.vertical, 12)
        .fixedSize(horizontal: false, vertical: true)
        .cardBackgroundModifier(
            backgroundColor: .white,
            borderColor: .purpleApp,
            cornerRadius: 20)
    }
}

#Preview {
    StatisticsRowView(tasksCount: 0, habitsCount: 0, expensesToday: 0)
}

