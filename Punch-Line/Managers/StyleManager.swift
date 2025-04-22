//
//  StyleManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

final class StyleManager {

    static var createOrJoinBackgroundColor = generateRandomBackgroundColor()
    static var jokeLookupBackgroundColor = generateRandomBackgroundColor()

    struct PunchLineColors {
        static let pink = Color(red: 217.0, green: 120.0, blue: 127.0)
    }

    class func generateRandomBackgroundColor() -> Color {
        let hue = Double(Int.random(in: 0...360)) / 360
        let saturation = Double(Int.random(in: 8...21)) / 100
        let brightness = Double(Int.random(in: 89...96)) / 100
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }

    class func generateNewJokeLookupBackgroundColor() {
        jokeLookupBackgroundColor = generateRandomBackgroundColor()
    }

}
