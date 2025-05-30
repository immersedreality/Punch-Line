//
//  String+TrimTrailingWhiteSpace.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 5/30/25.
//

import Foundation

extension String {

    func trimTrailingWhiteSpace() -> String {
        var trimmedSelf = self

        while trimmedSelf.last?.isWhitespace == true {
            trimmedSelf = String(trimmedSelf.dropLast())
        }

        return trimmedSelf
    }

}
