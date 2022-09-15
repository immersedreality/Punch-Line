//
//  UITextField+AddBottomBorder.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension UITextField {

    func addBottomBorderOf(color: UIColor) {
        self.layer.sublayers?.removeAll { $0 is TextInputBottomBorderLayer }
        let bottomBorder = TextInputBottomBorderLayer(color: color)
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.height + 4.0, width: self.frame.width, height: 1.0)
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomBorder)
    }

}

class TextInputBottomBorderLayer: CALayer {

    init(color: UIColor) {
        super.init()
        self.backgroundColor = color.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
