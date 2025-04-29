//
//  ActivePunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/22/25.
//

import Foundation

protocol ActivePunchLine: Codable, Identifiable {
    var id: String { get }
    var displayName: String { get }
}
