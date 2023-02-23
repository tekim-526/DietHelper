//
//  GenderButton.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

class OnboardingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setButton(title: String) {
        var config = UIButton.Configuration.bordered()
        var string = AttributedString.init(title)
        string.font = .systemFont(ofSize: 16, weight: .medium)
        string.foregroundColor = .black
        
        config.attributedTitle = string
        config.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        self.configuration = config
    }
}
