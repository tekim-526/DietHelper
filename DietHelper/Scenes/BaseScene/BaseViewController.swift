//
//  BaseViewController.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        configureUI()
        makeConstraints()
        view.backgroundColor = .white
    }
    func configureUI() {}
    func makeConstraints() {}
    
    func changeScene(viewController: UIViewController, delay: UInt32 = 0) {
        DispatchQueue.main.async {
            sleep(delay)
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let vc = viewController
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
}
