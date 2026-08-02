//
//  CardBackgroundModifier.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    var backgroundColor: Color
    var borderColor: Color
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                borderColor.opacity(0.1),
                                lineWidth: 1.5
                            )
                    }
            }
    }
}

extension View {
    func cardBackgroundModifier(
        backgroundColor: Color,
        borderColor: Color,
        cornerRadius: CGFloat = 36
    ) -> some View {
        self.modifier(
            CardBackgroundModifier(
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                cornerRadius: cornerRadius
            )
        )
    }
}

