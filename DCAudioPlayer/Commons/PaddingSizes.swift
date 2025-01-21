//
//  PaddingSizes.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//

import Foundation

enum Paddings {
    case paddingS
    case paddingM
    case paddingL
    case paddingXL
    case custom(CGFloat)

    var size: CGFloat {
        switch self {
        case .paddingS:
            return 6
        case .paddingM:
            return 8
        case .paddingL:
            return 16
        case .paddingXL:
            return 24
        case .custom(let value):
            return value
        }
    }
}
extension CGFloat {
    static var paddingS: CGFloat { Paddings.paddingS.size }
    static var paddingM: CGFloat { Paddings.paddingM.size }
    static var paddingL: CGFloat { Paddings.paddingL.size }
    static var paddingXL: CGFloat { Paddings.paddingXL.size }
    static func custom(_ value: CGFloat) -> CGFloat {
        Paddings.custom(value).size
    }
}
