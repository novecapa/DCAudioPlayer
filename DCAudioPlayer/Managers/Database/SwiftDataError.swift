//
//  SwiftDataError.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation

enum SwiftDataError: Error {
    case errorSave(String)
    case errorFetch(String)
    case errorSearch(String)
    case errorDelete(String)
}
