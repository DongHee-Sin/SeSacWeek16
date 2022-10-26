//
//  ValidationView.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit
import SnapKit
import Then


final class ValidationView: BaseView {
    
    // MARK: - Propertys
    let stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 12
        $0.axis = .vertical
    }
    
    let userNameTextField = UITextField().then {
        $0.backgroundColor = .lightGray
    }
    let userNameLabel = UILabel().then {
        $0.text = "아이디는 6글자 이상 입력해주세요."
        $0.textColor = .red
    }
    
    let passwordTextField = UITextField().then {
        $0.backgroundColor = .lightGray
    }
    let passwordLabel = UILabel().then {
        $0.text = "비밀번호는 9글자 이상 입력해주세요."
        $0.textColor = .red
    }
    
    let signUpButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.setTitle("가입하기", for: .normal)
    }
    
    
    
    
    // MARK: - Methdos
    override func configureUI() {
        self.backgroundColor = .white
        
        [userNameTextField, userNameLabel, passwordTextField, passwordLabel, signUpButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }
    
    
    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.edges.equalTo(self).inset(50)
            make.centerX.equalTo(self)
        }
    }
}
