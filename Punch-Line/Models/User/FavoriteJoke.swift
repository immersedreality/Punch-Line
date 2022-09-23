//
//  FavoriteJoke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct FavoriteJoke {
    let owningUser: CKRecord.Reference
    let setup: String
    let setupAuthor: String
    let punchline: String
    let punchlineAuthor: String
}
