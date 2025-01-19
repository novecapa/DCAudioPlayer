//
//  UtilsProtocol.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation

protocol UtilsProtocol {
    var getCurrentMillis: Double { get }
    var getDocumentsDirectory: URL { get }
    func getMP3Path(_ fileName: String) -> URL
    var getFileManager: FileManager { get }
    func createDirectory(directoryName: String)
    var hasConnection: Bool { get }
    var bundleId: String { get }
    var appVersion: String { get }
    var osVersion: String { get }
    var buildVersion: String { get }
}
