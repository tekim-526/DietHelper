//
//  SettingView.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/02/23.
//

import UIKit

class SettingView: OnboardingView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func makeConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let between = 12
        let horizontalEdges = 28
        let verticalEdges = 32
        let textFieldHeight = 56
        

        
        ageTextField.snp.remakeConstraints { make in
            make.top.equalTo(safeArea).offset(verticalEdges)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
        heightTextField.snp.remakeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(verticalEdges)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
        weightTextField.snp.remakeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(verticalEdges)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
        sliderDescriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(verticalEdges)
            make.leading.equalTo(safeArea).offset(horizontalEdges)
        }
        slider.snp.remakeConstraints { make in
            make.top.equalTo(sliderDescriptionLabel.snp.bottom).offset(between)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
        }
        
    }
}
