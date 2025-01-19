//
//  Number+Extensions.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation

// MARK: Int
extension Int {
    var toString: String {
        "\(self)"
    }

    var toDouble: Double {
        Double(self)
    }
}

// MARK: Double
extension Double {
    var toString: String {
        "\(self)"
    }

    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    var toFloat: Float {
        Float(self)
    }

    var toInt: Int {
        Int(self)
    }

    var toTimming: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return buildDurationString(hours: hours, minutes: minutes, seconds: seconds)
    }

    private func buildDurationString(hours: Int, minutes: Int, seconds: Int) -> String {
        let hoursString = hours > 0 ? String(format: "%02d:", hours) : ""
        let minutesString = String(format: "%02d:", minutes)
        let secondsString = String(format: "%02d", seconds)
        return hoursString + minutesString + secondsString
    }
}
