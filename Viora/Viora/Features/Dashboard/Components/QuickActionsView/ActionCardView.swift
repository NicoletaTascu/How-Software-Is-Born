//
//  ActionCardView.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

struct ActionCardView: View {
    let type: QuickActionType
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: type.icon)
                .font(.subheadline)
                .foregroundStyle(type.backgroundColor)
                .padding(10)
                .background {
                    Circle()
                        .fill(type.backgroundColor.opacity(0.08))
                }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(String(localized: type.emptyTitleKey))
                    .font(.subheadline)
                Text(String(localized: type.emptySubtitleKey))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(20)
        .cardBackgroundModifier(
            backgroundColor: type.backgroundColor,
            borderColor: type.backgroundColor,
            cornerRadius: 20
        )
    }
}

#Preview {
    ActionCardView(type: .habits)
}

