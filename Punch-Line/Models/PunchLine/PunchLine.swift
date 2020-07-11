//
//  PunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

protocol PunchLine {
    var id: String { get set }
    var name: String { get set }
    var activeSetups: List<Setup> { get }
    var activeJokes: List<Joke> { get }
    var survivingJokes: List<Joke> { get }
    var nameWithoutSpaces: String { get }
    var realmPath: String { get }
}
