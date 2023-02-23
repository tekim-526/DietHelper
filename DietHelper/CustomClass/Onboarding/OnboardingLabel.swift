//
//  OnboardingLabel.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

class OnboardingLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setLabel() {
        self.textColor = .lightGray
        self.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
