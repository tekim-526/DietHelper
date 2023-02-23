//
//  SettingViewController.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/02/23.
//

import UIKit

import RxCocoa
import RxSwift

class SettingViewController: OnboardingViewController {
    let settingView = SettingView()
    override func loadView() {
        view = settingView
    }
    override func viewDidLoad() {
        let barButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        barButtonItem.isEnabled = true
        navigationItem.rightBarButtonItem = barButtonItem
        
        settingView.backgroundColor = .white
        settingView.maleButton.isHidden = true
        settingView.femaleButton.isHidden = true
        settingView.genderLabel.isHidden = true
        settingView.startButton.isHidden = true
        additionalBind()
    }
    func additionalBind() {
        guard let user = user.fetchDataThroughDate(date: Date()) else { return }
        settingView.ageTextField.text = "\(user.age)"
        settingView.heightTextField.text = "\(user.height)"
        settingView.weightTextField.text = "\(user.weight)"
        settingView.slider.value = user.exerciseLevel
        
        
        navigationItem.rightBarButtonItem!.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let age = Int(vc.settingView.ageTextField.text!) ?? 20
                let exerciseLevel = vc.settingView.slider.value
                let height = Double(vc.settingView.heightTextField.text!) ?? 170
                let weight = Double(vc.settingView.weightTextField.text!) ?? 70
                let isMale = vc.user.fetchDataThroughDate(date: Date())?.isMale ?? true
                vc.user.updateData(age: Int64(age), weight: weight, height: height, exerciseLevel: exerciseLevel)
            }.disposed(by: viewModel.disposebag)
    }
    
}
