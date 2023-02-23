//
//  OnboardingView.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit
import SnapKit
import TextFieldEffects

class OnboardingView: BaseView {
    let genderLabel: OnboardingLabel = {
        let label = OnboardingLabel()
        label.text = "성별"
        return label
    }()
    
    let maleButton: OnboardingButton = {
        let button = OnboardingButton()
        button.setButton(title: "남성")
        button.configuration?.baseBackgroundColor = .systemMint
        return button
    }()
    
    let femaleButton: OnboardingButton = {
        let button = OnboardingButton()
        button.setButton(title: "여성")
        return button
    }()
    
    let ageTextField: OnboardingTextField = {
        let tf = OnboardingTextField()
        tf.placeholder = "나이를 입력해 주세요"
        tf.keyboardType = .numberPad
        return tf
    }()
    
    let heightTextField: OnboardingTextField = {
        let tf = OnboardingTextField()
        tf.placeholder = "키(신장)를 입력해 주세요(cm)"
        return tf
    }()
   
    let weightTextField: OnboardingTextField = {
        let tf = OnboardingTextField()
        tf.placeholder = "몸무게(체중)를 입력해 주세요(kg)"
        return tf
    }()
    
    let sliderDescriptionLabel: OnboardingLabel = {
        let label = OnboardingLabel()
        label.text = "주당 운동량 (1 ~ 5)"
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.tintColor = .systemMint
        return slider
    }()
    let startButton: OnboardingButton = {
        let button = OnboardingButton()
        button.setButton(title: "시작하기")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [genderLabel, maleButton, femaleButton, ageTextField, heightTextField, weightTextField, sliderDescriptionLabel, slider, startButton].forEach { self.addSubview($0) }
    }
    
    override func makeConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let between = 12
        let horizontalEdges = 28
        let verticalEdges = 32
        let textFieldHeight = 56
        
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(femaleButton.snp.centerY)
            make.leading.equalTo(safeArea).offset(horizontalEdges)
        }
        femaleButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(verticalEdges)
            make.trailing.equalTo(safeArea).offset(-horizontalEdges)
        }
        maleButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(verticalEdges)
            make.trailing.equalTo(femaleButton.snp.leading).offset(-between)
        }
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(maleButton.snp.bottom).offset(verticalEdges)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(verticalEdges)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(verticalEdges)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
        sliderDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(verticalEdges)
            make.leading.equalTo(safeArea).offset(horizontalEdges)
        }
        slider.snp.makeConstraints { make in
            make.top.equalTo(sliderDescriptionLabel.snp.bottom).offset(between)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-verticalEdges / 2)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(40)
        }
    }
}
