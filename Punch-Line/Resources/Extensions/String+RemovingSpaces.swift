//
//  String+RemovingSpaces.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/10/25.
//

import Foundation

extension String {

    func removingSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

}
