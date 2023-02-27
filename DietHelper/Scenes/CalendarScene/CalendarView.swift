//
//  CalendarView.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

import FSCalendar
import SnapKit

class CalendarView: BaseView {
    let bmrButton: BMRAMRButton = {
        let button = BMRAMRButton()
        return button
    }()
    let amrButton: BMRAMRButton = {
        let button = BMRAMRButton()
        return button
    }()
    let resultButton: BMRAMRButton = {
        let button = BMRAMRButton()
        return button
    }()
    
    let bmramrStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.eventDefaultColor = .lightGray
        calendar.appearance.selectionColor = .lightGray
        return calendar
    }()
   
    let gainedCaloriesTextField: OnboardingTextField = {
        let tf = OnboardingTextField()
        tf.placeholder = "오늘 먹은 음식의 칼로리(kcal)를 알려주세요."
        return tf
    }()
    
    let consumedCaloriesTextField: OnboardingTextField = {
        let tf = OnboardingTextField()
        tf.placeholder = "오늘 운동등으로 소비한 칼로리(kcal)를 알려주세요."
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [calendar, bmramrStackView, gainedCaloriesTextField, consumedCaloriesTextField].forEach { self.addSubview($0) }
        [bmrButton, amrButton, resultButton].forEach { bmramrStackView.addArrangedSubview($0) }
    }
    override func makeConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let horizontalEdges = 40
        let textFieldHeight = 56
        bmramrStackView.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(calendar.snp.bottom)//.offset(top)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(self.snp.height).multipliedBy(0.07)
        }
        calendar.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(self.snp.height).multipliedBy(0.36)
        }
        
        gainedCaloriesTextField.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(bmramrStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
        consumedCaloriesTextField.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(gainedCaloriesTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalEdges)
            make.height.equalTo(textFieldHeight)
        }
    }
}
