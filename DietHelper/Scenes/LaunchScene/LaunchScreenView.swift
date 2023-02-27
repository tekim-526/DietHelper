//
//  LaunchScreenView.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/01/31.
//

import UIKit
import SnapKit

class LaunchScreenView: BaseView {
    let label: UILabel = {
        let label = UILabel()
        label.text = "DIET\nHelper"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
