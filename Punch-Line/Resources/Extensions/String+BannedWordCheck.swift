//
//  String+BannedWordCheck.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/17/25.
//

import Foundation

extension String {

    func containsBannedWords() -> Bool {
        let subStrings = self.split(separator: " ")
        for subString in subStrings {
            if BannedWords.contains(String(subString)) {
                return true
            }
        }
        return false
    }

}
