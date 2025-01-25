//
//  Utils.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation
import SystemConfiguration
import UIKit

class Utils: UtilsProtocol {

    enum Constants {
        static let shortVersion = "CFBundleShortVersionString"
        static let bundleVersion = "CFBundleVersion"
        static let nVersion = "0.0.0"
        static let nBundleId = "no.bundle.podcaster"
        static let audioFolder = "audio"
    }

    // MARK: Date
    var getCurrentMillis: Double {
        (Date().timeIntervalSince1970 * 1000).rounded()
    }

    // MARK: Files and folders
    var getDocumentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    var getFileManager: FileManager {
        FileManager.default
    }

    func createDirectory(directoryName: String) {
        if directoryName.isEmpty {
            return
        }

        let fileManager = getFileManager
        let documentsDirectory = getDocumentsDirectory

        guard !fileManager.fileExists(atPath: documentsDirectory.appendingPathComponent(directoryName).path) else {
            return
        }
        try? fileManager.createDirectory(atPath: documentsDirectory
            .appendingPathComponent(directoryName)
            .relativePath, withIntermediateDirectories: true, attributes: nil)
    }

    func getFilePath(_ fileName: String) -> URL {
        let pdfFolder = getDocumentsDirectory.appendingPathComponent(Constants.audioFolder)
        return pdfFolder.appendingPathComponent(fileName)
    }

    // MARK: - Check Internet connection
    var hasConnection: Bool {
        Reachability.isConnectedToNetwork()
    }

    // MARK: App
    var bundleId: String {
        if let text = Bundle.main.bundleIdentifier {
            return text
        } else {
            return Constants.nBundleId
        }
    }

    var appVersion: String {
        guard let shortVersion = Bundle.main.infoDictionary?[Constants.shortVersion] as? String,
              let bundleVersion = Bundle.main.infoDictionary?[Constants.bundleVersion] as? String else {
            return Constants.nVersion
        }
        return "V. \(shortVersion) (\(bundleVersion))"
    }

    var osVersion: String {
        UIDevice.current.systemVersion
    }

    var buildVersion: String {
        guard let bundleVersion = Bundle.main.infoDictionary?[Constants.bundleVersion] as? String else {
            return "-1"
        }
        return bundleVersion
    }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
