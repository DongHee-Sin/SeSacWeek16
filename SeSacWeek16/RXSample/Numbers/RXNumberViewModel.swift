//
//  RXNumberViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import Foundation
import RxSwift


final class RXNumberViewModel {
    
    // MARK: - Propertys
    var number1 = PublishSubject<Int>()
    var number2 = PublishSubject<Int>()
    var number3 = PublishSubject<Int>()
}
