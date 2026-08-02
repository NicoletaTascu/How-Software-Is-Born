//
//  QuickActionType.swift
//  Viora
//
//  Created by tascu nicoleta on 02/08/2026.
//

import SwiftUI

enum QuickActionType: String, CaseIterable {
    case tasks
    case habits
    case expenses
    case goal

    var icon: String {
        switch self {
        case .tasks:
            return "list.bullet"
        case .habits:
            return "flame.fill"
        case .expenses:
            return "creditcard"
        case .goal:
            return "target"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .tasks:
            return .purpleApp
        case .habits:
            return .purpleApp
        case .expenses:
            return .blueApp
        case .goal:
            return .orangeApp
        }
    }

    var emptyTitleKey: String.LocalizationValue {
        switch self {
        case .tasks:
            return "empty_tasks_title"
        case .habits:
            return "empty_habits_title"
        case .expenses:
            return "empty_expenses_title"
        case .goal:
            return "empty_goal_title"
        }
    }

    var emptySubtitleKey: String.LocalizationValue {
        switch self {
        case .tasks:
            return "empty_tasks_subtitle"
        case .habits:
            return "empty_habits_subtitle"
        case .expenses:
            return "empty_expenses_subtitle"
        case .goal:
            return "empty_goal_subtitle"
        }
    }
    
    var titleKey: String.LocalizationValue {
        switch self {
        case .tasks:
            return "empty_tasks_title"
        case .habits:
            return "empty_habits_title"
        case .expenses:
            return "empty_expenses_title"
        case .goal:
            return "empty_goal_title"
        }
    }

    var subtitleKey: String.LocalizationValue {
        switch self {
        case .tasks:
            return "empty_tasks_subtitle"
        case .habits:
            return "empty_habits_subtitle"
        case .expenses:
            return "empty_expenses_subtitle"
        case .goal:
            return "empty_goal_subtitle"
        }
    }
}
