//
//  CalendarViewController.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

import RxCocoa
import RxSwift

class CalendarViewController: BaseViewController {
    let calendarView = CalendarView()
    let viewModel = CalendarViewModel()
    override func loadView() {
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        barButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = barButtonItem
        bind()
        print("💡\n", viewModel.user.fetchData())
    }
    
    func bind() {
        let output = viewModel.transform(input: CalendarViewModel.Input(
            gainedCalInput: calendarView.gainedCaloriesTextField.rx.text,
            consumedCalInput: calendarView.consumedCaloriesTextField.rx.text,
            rightBarButtonTap: navigationItem.rightBarButtonItem!.rx.tap)
        )
        output.dataIsEmpty
            .withUnretained(self)
            .bind { vc, isempty in
                print("⚙️ fetchDate\n", vc.viewModel.user.fetchDataThroughDate(date: Date())!)
                guard let gained = vc.viewModel.user.fetchDataThroughDate(date: Date())?.gainedCalories else { return }
                guard let consumed = vc.viewModel.user.fetchDataThroughDate(date: Date())?.consumedCalories else { return }
                vc.calendarView.gainedCaloriesTextField.text = "\(gained)"
                vc.calendarView.consumedCaloriesTextField.text = "\(consumed)"
            }.disposed(by: viewModel.disposebag)
        output.bmr
            .withUnretained(self)
            .bind { vc, bmr in
                vc.calendarView.bmrButton.setButton(title: "기초대사량\n\(bmr)")
                vc.calendarView.resultButton.setButton(title: "결과\n\(bmr)")
            }.disposed(by: viewModel.disposebag)
        output.amr
            .withUnretained(self)
            .bind { vc, amr in
                vc.calendarView.amrButton.setButton(title: "활동대사량\n\(amr)")
            }.disposed(by: viewModel.disposebag)
        
        output.result
            .withUnretained(self)
            .bind { vc, result  in
                guard let consumed = Int(result.0 ?? "0") else { return }
                guard let gained = Int(result.1 ?? "0") else { return }
                vc.calendarView.resultButton.setButton(title: "결과\n\(gained - consumed + result.2)")
            }.disposed(by: viewModel.disposebag)
        output.validation
            .withUnretained(self)
            .bind { vc, valid in
                self.navigationItem.rightBarButtonItem?.isEnabled = valid
                print(valid)
            }.disposed(by: viewModel.disposebag)
        output.rightBarButtonTap
            .withUnretained(self)
            .bind { vc, _ in
                guard let gained = Int(vc.calendarView.gainedCaloriesTextField.text!) else { return }
                guard let consumed = Int(vc.calendarView.consumedCaloriesTextField.text!) else { return }
                vc.viewModel.user.updateCalories(date: Date(), gainedCalories: gained, consumedCalories: consumed)
                
            }.disposed(by: viewModel.disposebag)
    }
    
}
