//
//  OnboardingViewModel.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

import RxCocoa
import RxSwift
import CoreData

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class OnboardingViewModel: ViewModelType {
    var disposebag = DisposeBag()
    var strArr = BehaviorSubject(value: ["김태수A", "김태수B", "김태수C"])
    // Input
    
    
    struct Input {
        var ageInput: ControlProperty<String?>
        var heightInput: ControlProperty<String?>
        var weightInput: ControlProperty<String?>
        var maleButtonInput: ControlEvent<Void>
        var femaleButtonInput: ControlEvent<Void>
        var sliderInput: ControlProperty<Float>
        var startButtonInput: ControlEvent<Void>
    }
    
    struct Output {
        var strArrOut: Observable<[String]>
        var age: Driver<String?>
        var height: Driver<String?>
        var weight: Driver<String?>
        var validation: Observable<Bool>
        var maleButton: ControlEvent<Void>
        var femaleButton: ControlEvent<Void>
        var slider: Driver<Float>
        var startButton: ControlEvent<Void>
    }
    
    
    
    func transform(input: Input) -> Output {
        let ageValid = input.ageInput.orEmpty.map { age in
            !age.isEmpty && age.count < 3
        }
        let weightValid = input.weightInput.orEmpty.map { weight in
            !weight.isEmpty && weight.count < 6
        }
        let heightvalid = input.heightInput.orEmpty.map { height in
            !height.isEmpty && height.count < 6
        }
       
        
        let a = strArr.map { $0.map { $0 + "님" } }
        
        let valid = Observable.combineLatest(ageValid, heightvalid, weightValid)
            .map { $0 == true && $1 == true && $2 == true }
        
        return Output(strArrOut: a,
                      age: input.ageInput.asDriver(),
                      height: input.heightInput.asDriver(),
                      weight: input.weightInput.asDriver(),
                      validation: valid,
                      maleButton: input.maleButtonInput,
                      femaleButton: input.femaleButtonInput,
                      slider: input.sliderInput.asDriver(),
                      startButton: input.startButtonInput)
    }
    
}
