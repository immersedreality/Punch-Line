//
//  Punchline+TextViewDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 11/3/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PunchlineViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" { return true }

        if range.location > 280 {
            return false
        } else {
            if text == "\n" {
                doneButtonTapped(self)
                return false
            } else {
                return true
            }
        }
    }
    
}
