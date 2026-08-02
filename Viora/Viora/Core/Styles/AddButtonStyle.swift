//
//  AddButtonStyle.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

struct AddButtonStyle: ButtonStyle {

    var backgroundColor: Color
    var height: CGFloat = 50.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.white)
            .foregroundStyle(backgroundColor)
            .clipShape(.capsule)
            .scaleEffect(
                configuration.isPressed ? 0.96 : 1
            )
            .shadow(
                color: backgroundColor.opacity(
                    configuration.isPressed ? 0.18 : 0.20
                ),
                radius: configuration.isPressed ? 2 : 8,
                x: 0,
                y: configuration.isPressed ? 4 : 6
            )
            .animation(
                .spring(
                    response: 0.25,
                    dampingFraction: 0.7
                ),
                value: configuration.isPressed
            )
    }
}

