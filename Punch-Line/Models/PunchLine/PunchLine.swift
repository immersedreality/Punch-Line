//
//  PunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

protocol PunchLine {
    var id: String { get }
    var name: String { get }
    var activeSetups: [Setup] { get }
    var activeJokes: [Joke] { get }
    var survivingJokes: [Joke] { get }
}
