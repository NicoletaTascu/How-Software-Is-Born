//
//  EmptyTaskView.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

struct EmptyTaskView: View {
    let onAddTask: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("today_tasks")
                    .font(.headline)
                Spacer()
                
                Button {
                    
                } label: {
                    Text(String(localized: "see_all"))
                        .font(.caption)
                        .foregroundStyle(.purpleApp.opacity(0.9))
                }
            }
            HStack(spacing: 12) {
                Circle()
                    .fill(.purpleApp.opacity(0.1))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "list.bullet.clipboard")
                            .foregroundStyle(.purpleApp.opacity(0.5))
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text("empty_today_task_title")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(String(localized: "empty_today_task_subtitle"))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    onAddTask()
                } label: {
                    Text(String(localized: "add_new_task"))
                }
                .buttonStyle(
                    AddButtonStyle(
                        backgroundColor: .purpleApp
                    )
                )
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
    EmptyTaskView(onAddTask: {})
}

