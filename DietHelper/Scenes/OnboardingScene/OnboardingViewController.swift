//
//  OnboardingViewController.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

import RxCocoa
import RxSwift

class OnboardingViewController: BaseViewController {
    let onboardingView = OnboardingView()
    let viewModel = OnboardingViewModel()
    let disposebag = DisposeBag()
    var isMale = true
    var user = User()
    
    override func loadView() {
        view = onboardingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    func bind() {
        let input = OnboardingViewModel.Input(ageInput: onboardingView.ageTextField.rx.text,
                                              heightInput: onboardingView.heightTextField.rx.text,
                                              weightInput: onboardingView.weightTextField.rx.text,
                                              maleButtonInput: onboardingView.maleButton.rx.tap,
                                              femaleButtonInput:
                                                onboardingView.femaleButton.rx.tap,
                                              sliderInput: onboardingView.slider.rx.value,
                                              startButtonInput: onboardingView.startButton.rx.tap)
        
        let output = viewModel.transform(input: input)

        output.strArrOut
            .bind { str in
                print(str.isEmpty)
                print(str)
            }.disposed(by: disposebag)

        output.maleButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.onboardingView.maleButton.configuration?.baseBackgroundColor = .systemMint
                vc.onboardingView.femaleButton.configuration?.baseBackgroundColor = .systemGray6
                vc.isMale = true
        }.disposed(by: disposebag)
        
        output.femaleButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.onboardingView.femaleButton.configuration?.baseBackgroundColor = .systemMint
                vc.onboardingView.maleButton.configuration?.baseBackgroundColor = .systemGray6
                vc.isMale = false
        }.disposed(by: disposebag)
        
        output.age.drive { [unowned self] age in
            guard let age else {return}
            if age.isEmpty { return }
            if age.count > 3 { self.onboardingView.ageTextField.text?.removeLast() }
            if Int(age) == nil {
                self.onboardingView.ageTextField.text?.removeLast()
            }
        }.disposed(by: disposebag)
        
        output.weight.drive { [unowned self] weight in
            guard let weight else {return}
            if weight.isEmpty { return }
            if weight.count > 6 { self.onboardingView.weightTextField.text?.removeLast() }
            if Double(weight) == nil {
                self.onboardingView.weightTextField.text?.removeLast()
            }
        }.disposed(by: disposebag)
        
        output.height.drive { [unowned self] height in
            guard let height else { return }
            if height.isEmpty { return }
            if height.count > 6 { self.onboardingView.heightTextField.text?.removeLast() }
            if Double(height) == nil {
                self.onboardingView.heightTextField.text?.removeLast()
            }
        }.disposed(by: disposebag)
        
        output.slider.drive { [unowned self] value in
            let value = Float(value)
            onboardingView.sliderDescriptionLabel.text = "주당 운동량 (1 ~ 5) " + "\(value.rounded())"
        }.disposed(by: disposebag)
        
        output.validation
            .withUnretained(self)
            .bind { vc, bool in
                vc.onboardingView.startButton.isEnabled = bool
                vc.onboardingView.startButton.configuration?.baseBackgroundColor = bool ? .systemMint : .systemGray5
            }.disposed(by: disposebag)
        
        output.startButton
            .withUnretained(self)
            .bind { vc, _ in
                let age = Int(vc.onboardingView.ageTextField.text!) ?? 20
                let exerciseLevel = vc.onboardingView.slider.value
                let height = Double(vc.onboardingView.heightTextField.text!) ?? 170
                let weight = Double(vc.onboardingView.weightTextField.text!) ?? 70
                let isMale = vc.isMale
                let profile = Profile(age: age, exerciseLevel: exerciseLevel, height: height, weight: weight, isMale: isMale)
                vc.user.profile = profile
                vc.changeScene(viewController: TabbarContoller())
            }.disposed(by: disposebag)
    }
}
