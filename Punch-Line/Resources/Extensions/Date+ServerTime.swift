//
//  Date+ServerTime.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 6/1/25.
//

import Foundation

extension Date {

    static func startOfDayInServerTime(from date: Date) -> Date {
        guard let serverTimeZone = TimeZone(identifier: "America/New_York") else { return Date() }
        var calendar = Calendar.current
        calendar.timeZone = serverTimeZone
        return calendar.startOfDay(for: date)
    }

}
