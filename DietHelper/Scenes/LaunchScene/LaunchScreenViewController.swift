//
//  LaunchScreenViewController.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

class LaunchScreenViewController: BaseViewController {
    let launchScreenView = LaunchScreenView()
    let viewModel = OnboardingViewModel()
    let user = User()
    override func loadView() {
        view = launchScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        if user.fetchData().isEmpty {
            changeScene(viewController: OnboardingViewController(), delay: 3)
        } else {
            changeScene(viewController: TabbarContoller(), delay: 3)
        }
    }
    
    
}
