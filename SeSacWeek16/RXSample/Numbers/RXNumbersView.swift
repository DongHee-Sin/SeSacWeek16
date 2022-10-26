//
//  RXNumbersView.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit
import SnapKit


final class RXNumbersView: BaseView {
    
    // MARK: - Propertys
    private lazy var numberStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 8
        view.backgroundColor = .white
        view.isLayoutMarginsRelativeArrangement = true
        [textField1, textField2, textField3].forEach {
            view.addArrangedSubview($0)
        }
        return view
    }()
    
    let textField1 = {
        let view = UITextField()
        view.backgroundColor = .lightGray
        view.keyboardType = .numberPad
        return view
    }()
    let textField2 = {
        let view = UITextField()
        view.backgroundColor = .lightGray
        view.keyboardType = .numberPad
        return view
    }()
    let textField3 = {
        let view = UITextField()
        view.backgroundColor = .lightGray
        view.keyboardType = .numberPad
        return view
    }()
    
    let resultLabel = UILabel()
    
    
    
    // MARK: - Methdos
    override func configureUI() {
        self.backgroundColor = .white
        
        [numberStackView, resultLabel].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        numberStackView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.width.equalTo(100)
            make.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(numberStackView.snp.bottom).offset(20)
            make.centerX.equalTo(numberStackView)
        }
    }
}
