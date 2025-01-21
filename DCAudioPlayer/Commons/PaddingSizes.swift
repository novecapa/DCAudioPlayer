//
//  PaddingSizes.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//

import Foundation

enum Paddings {
    case light
    case regular
    case medium
    case heavy

    var size: CGFloat {
        switch self {
        case .light:
            return 6
        case .regular:
            return 8
        case .medium:
            return 16
        case .heavy:
            return 24
        }
    }
}
extension CGFloat {
    static var paddingLight: CGFloat { Paddings.light.size }
    static var paddingRegular: CGFloat { Paddings.regular.size }
    static var paddingMedium: CGFloat { Paddings.medium.size }
    public static var paddingHeavy: CGFloat { Paddings.heavy.size }
}
