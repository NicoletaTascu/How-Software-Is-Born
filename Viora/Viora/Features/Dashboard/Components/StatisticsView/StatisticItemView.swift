//
//  StatisticItemView.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

struct StatisticItemView: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String.LocalizationValue
    let sublabel: String.LocalizationValue
    var labelColor: Color = .purpleApp
    var valueColor: Color = .primary
    var withCurrency = false
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(iconColor.opacity(0.12))
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: icon)
                        .font(.headline)
                        .foregroundStyle(iconColor)
                }
            Group {
                if withCurrency, let amount = Double(value) {
                    Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                } else if let number = Double(value) {
                    Text(number, format: .number)
                } else {
                    Text(value)
                }
            }
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(valueColor)

            Text(String(localized: label))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(labelColor)

            Text(String(localized: sublabel))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatisticItemView(icon: "checkmark.circle", iconColor: .purpleApp, value: "0", label: "task", sublabel: "today")
}

