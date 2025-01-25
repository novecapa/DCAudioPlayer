//
//  IconsSystem.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//

import Foundation

enum IconsSystem {
    case trash
    case arrowDown
    case airpodsMax
    case userCircle(Bool)
    case backward(Int)
    case forward(Int)

    var icon: String {
        switch self {
        case .trash:
            "trash"
        case .arrowDown:
            "chevron.down"
        case .airpodsMax:
            "airpods.max"
        case .userCircle(let filled):
            filled ? "person.circle.fill" : "person.circle.fill"
        case .backward(let seconds):
            "gobackward.\(seconds)"
        case .forward(let seconds):
            "goforward.\(seconds)"
        }
    }
}
extension String {
    static var trash: String {
        IconsSystem.trash.icon
    }

    static var arrowDown: String {
        IconsSystem.arrowDown.icon
    }

    static var airpodsMax: String {
        IconsSystem.airpodsMax.icon
    }

    static func userCircle(_ filled: Bool) -> String {
        IconsSystem.userCircle(filled).icon
    }

    static func backward(_ seconds: Int) -> String {
        IconsSystem.backward(seconds).icon
    }

    static func forward(_ seconds: Int) -> String {
        IconsSystem.forward(seconds).icon
    }
}
