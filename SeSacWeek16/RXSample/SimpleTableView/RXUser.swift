//
//  RXUser.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/27.
//

import Foundation


struct RXUser: Hashable {
    var name: String
    var age: Int
    
    private let uuid = UUID()
}
