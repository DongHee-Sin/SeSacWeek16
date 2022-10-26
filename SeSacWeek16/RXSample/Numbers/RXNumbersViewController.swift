//
//  RXNumbersViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa


class RXNumbersViewController: BaseViewController {

    // MARK: - Propertys
    private let viewModel = RXNumberViewModel()
    
    
    
    
    // MARK: - LifeCycle
    let numbersView = RXNumbersView()
    override func loadView() {
        view = numbersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methdos
    override func configure() {
        numbersView.textField1.rx.text.orEmpty
            .map { Int($0) ?? 0 }
            .bind(to: viewModel.number1)
            .disposed(by: disposeBag)
        
        numbersView.textField2.rx.text.orEmpty
            .map { Int($0) ?? 0 }
            .bind(to: viewModel.number2)
            .disposed(by: disposeBag)
        
        numbersView.textField3.rx.text.orEmpty
            .map { Int($0) ?? 0 }
            .bind(to: viewModel.number3)
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(viewModel.number1, viewModel.number2, viewModel.number3)
            .bind { [weak self] (n1, n2, n3) in
                self?.numbersView.resultLabel.text = "\(n1 + n2 + n3)"
            }
            .disposed(by: disposeBag)
    }
}
