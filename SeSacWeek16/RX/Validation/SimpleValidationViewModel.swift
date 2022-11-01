//
//  SimpleValidationViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/27.
//

import Foundation

import RxSwift
import RxCocoa


final class SimpleValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요.")
    
    
    
    
    // MARK: - Input
    struct Input {
        let text: ControlProperty<String?>  // nameTextField.rx.text
        
        let tap: ControlEvent<Void>    // stepButton.rx.tap
    }
    
    
    // MARK: - Output
    struct Output {
        let validation: Observable<Bool>
        
        let tap: ControlEvent<Void>
        
        let text: Driver<String>
    }
    
    
    // MARK: - Input -> Output
    func transform(input: Input) -> Output {
        let valid = input.text.orEmpty
            .map { $0.count >= 8 }
            .share()
        
        let text = validText.asDriver()
        
        return Output(validation: valid, tap: input.tap, text: text)
    }
    
}
