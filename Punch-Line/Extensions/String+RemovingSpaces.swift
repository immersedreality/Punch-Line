//
//  String+RemovingSpaces.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

extension String {

    func removingSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

}
