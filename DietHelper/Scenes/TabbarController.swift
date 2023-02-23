//
//  TabbarController.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit

class TabbarContoller: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    func configureUI() {
        let vc1 = CalendarViewController()
        vc1.tabBarItem.image = UIImage(systemName: "calendar")
        let vc2 = SettingViewController()
        vc2.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        let nav = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        setViewControllers([nav, nav2], animated: true)
    }
}
