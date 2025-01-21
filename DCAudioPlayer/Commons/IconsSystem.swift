//
//  IconsSystem.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//

import Foundation

enum IconsSystem {
    case trash

    var icon: String {
        switch self {
        case .trash:
            "trash"
        }
    }
}
extension String {
    static var trash: String {
        IconsSystem.trash.icon
    }
}
