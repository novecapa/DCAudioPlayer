//
//  String+Extensions.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation

// MARK: String
extension String {
    var decodeB64: String {
        guard let base64String = self.data(using: .utf8),
              let decodedData = Data(base64Encoded: base64String),
              let decodedString = String(data: decodedData, encoding: .utf8)else {
            return ""
        }
        return decodedString
    }

    var timeMillis: Double {
        if let time = Double(self) {
            return time * 1000
        }
        return 0
    }

    var capitalizingFirstLetter: String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }

    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    var toDouble: Double {
        guard let value = Double(self) else {
            return 0.0
        }
        return value
    }
    var toInt: Int {
        guard let value = Int(self) else {
            return 0
        }
        return value
    }
    var removeLastZero: String {
        String(self.split(separator: ".0").first ?? "")
    }

    var toData: Data? {
        data(using: .utf8)
    }

    var isValidURL: Bool {
        let text = self
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)
        for match in detector.matches(in: text, options: [], range: fullRange) {
            if let range = Range(match.range, in: text) {
                let urlString = String(text[range])
                if let url = URL(string: urlString), isValidHost(url.host) {
                    return true
                }
            }
        }
        return false
    }

    private func isValidHost(_ host: String?) -> Bool {
        guard let host = host else { return false }
        let parts = host.split(separator: ".")
        return parts.count > 1 && parts.allSatisfy { part in part.count > 1 }
    }
}
