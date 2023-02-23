//
//  CalendarViewModel.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/02/21.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData

class CalendarViewModel: ViewModelType {
    let user = User()
    
    private var bmr = BehaviorRelay<Int>(value: 0)
    private var amr = BehaviorRelay<Int>(value: 0)
    
    var disposebag = DisposeBag()
    
    struct Input {
        var gainedCalInput: ControlProperty<String?>
        var consumedCalInput: ControlProperty<String?>
        var rightBarButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        var bmr: Observable<Int>
        var amr: Observable<Int>
        var result: Observable<(String?, String?, Int)>
        var validation: Observable<Bool>
        var rightBarButtonTap: ControlEvent<Void>
        var dataIsEmpty: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let dataIsEmpty = user.fetchDataThroughDate(date: Date()) == nil ? Observable.of(true) : Observable.of(false)

        let gainedValid = input.gainedCalInput.orEmpty.map { gained in
            !gained.isEmpty && gained.count < 6
        }
        let consumedValid = input.consumedCalInput.orEmpty.map { consumed in
            !consumed.isEmpty && consumed.count < 6
        }
        let valid = Observable.combineLatest(gainedValid, consumedValid).map { gValid, cValid in
            gValid == true && cValid == true
        }
        let result = Observable.combineLatest(input.consumedCalInput.asObservable(), input.gainedCalInput.asObservable(), bmr)
        
        bmr.accept(getBMRAMR().bmr)
        amr.accept(getBMRAMR().amr)
        
        return Output(bmr: bmr.asObservable(), amr: amr.asObservable(), result: result, validation: valid, rightBarButtonTap: input.rightBarButtonTap, dataIsEmpty: dataIsEmpty)
    }
    
    func getBMRAMR() -> (bmr: Int, amr: Int) {
        guard let data = user.fetchDataThroughDate(date: Date()) else { return (0, 0) }
        // 해리스 - 베네딕트 공식
        let tmpBMR: Double = data.isMale ? 88.4 + 13.4 * data.weight + 4.8 * data.height - 5.68 * Double(data.age) : 447.6 + 9.25 * data.weight + 3.1 * data.height - 4.33 * Double(data.age)
        
        let tmpAMR: Double = {
            switch Int(data.exerciseLevel.rounded()) {
            case 0..<1:
                return Double(tmpBMR) * 1.2
            case 1..<2:
                return Double(tmpBMR) * 1.375
            case 2..<3:
                return Double(tmpBMR) * 1.55
            case 3..<4:
                return Double(tmpBMR) * 1.725
            default:
                return Double(tmpBMR) * 1.9
            }
        }()
        return (Int(tmpBMR), Int(tmpAMR))
    }
}
