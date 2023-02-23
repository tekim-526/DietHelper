//
//  OnboardingTextField.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit
import TextFieldEffects

class OnboardingTextField: HoshiTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTextField()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTextField() {
        self.placeholderFontScale = 0.8
        self.placeholderColor = .lightGray
        self.borderInactiveColor = .lightGray
        self.borderActiveColor = .systemMint
        self.keyboardType = .decimalPad
    }
}
