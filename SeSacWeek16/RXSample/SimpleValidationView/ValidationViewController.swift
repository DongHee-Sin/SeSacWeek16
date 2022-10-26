//
//  ValidationViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa


final class ValidationViewController: BaseViewController {

    // MARK: - Propertys
    private let userName = PublishRelay<String>()
    private let password = PublishRelay<String>()
    
    
    
    
    // MARK: - Life Cycle
    let validationView = ValidationView()
    override func loadView() {
        view = validationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        validationView.userNameTextField.rx.text.orEmpty
            .bind(to: userName)
            .disposed(by: disposeBag)
        
        validationView.passwordTextField.rx.text.orEmpty
            .bind(to: password)
            .disposed(by: disposeBag)
        
        
        userName
            .map { $0.count > 5 }
            .withUnretained(self)
            .bind { (vc, value) in
                vc.validationView.userNameLabel.isHidden = value
                vc.validationView.passwordTextField.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        password
            .map { $0.count > 8 }
            .withUnretained(self)
            .bind { (vc, value) in
                vc.validationView.passwordLabel.isHidden = value
                vc.validationView.signUpButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        
        validationView.signUpButton.rx.tap
            .bind { _ in
                print("Button Tapped")
            }
            .disposed(by: disposeBag)
    }
}
