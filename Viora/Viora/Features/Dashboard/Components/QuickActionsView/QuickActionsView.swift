//
//  QuickActionsView.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

struct QuickActionsView: View {
    
    var body: some View {
        VStack {
            HStack {
                Text(String(localized: "quick_actions"))
                    .fontWeight(.semibold)
                Spacer()
                Text(String(localized: "see_all"))
                    .font(.subheadline)
                    .foregroundStyle(.purpleApp)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ActionCardView(type: .habits)
                    ActionCardView(type: .expenses)
                    ActionCardView(type: .goal)
                }
                //.padding(6)
            }
        }
        .padding()
        .cardBackgroundModifier(
            backgroundColor: .white,
            borderColor: .purpleApp,
            cornerRadius: 20)
    }
}

#Preview {
    QuickActionsView()
}
