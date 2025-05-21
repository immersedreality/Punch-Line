//
//  StyleManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

final class StyleManager {

    static let createOrJoinBackgroundColor = generateRandomBackgroundColor()
    static let createOrJoinSuccessBackgroundColor = generateRandomBackgroundColor()
    static let favoriteJokeListBackgroundColor = generateRandomBackgroundColor()
    static let jokeHistoryPunchLinesBackgroundColor = generateRandomBackgroundColor()
    static let jokeHistoryYearsBackgroundColor = generateRandomBackgroundColor()
    static let jokeHistoryMonthsBackgroundColor = generateRandomBackgroundColor()
    static let jokeHistoryEntriesBackgroundColor = generateRandomBackgroundColor()
    static let jokeListBackgroundColor = generateRandomBackgroundColor()
    static let jokeLookupBackgroundColor = generateRandomBackgroundColor()
    static let privatePunchLineListBackgroundColor = generateRandomBackgroundColor()
    static var currentActivityBackgroundColor = Color.white

    struct PunchLineColors {
        static let pink = Color(red: 217.0, green: 120.0, blue: 127.0)
    }

    class func generateRandomBackgroundColor() -> Color {
        let hue = Double(Int.random(in: 0...360)) / 360
        let saturation = Double(Int.random(in: 8...21)) / 100
        let brightness = Double(Int.random(in: 89...96)) / 100
        let generatedColor = Color(hue: hue, saturation: saturation, brightness: brightness)
        currentActivityBackgroundColor = generatedColor
        return generatedColor
    }

}
