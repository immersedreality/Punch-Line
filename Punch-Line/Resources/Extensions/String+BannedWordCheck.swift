//
//  String+BannedWordCheck.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/17/25.
//

import Foundation

extension String {

    func containsBannedWords() -> Bool {
        for bannedWord in AppConstants.BannedWords {
            if self.contains(bannedWord) {
                return true
            }
        }
        return false
    }

}
