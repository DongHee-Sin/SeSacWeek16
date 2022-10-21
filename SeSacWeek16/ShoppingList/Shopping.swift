//
//  Shopping.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/22.
//

import Foundation


enum Importance: Int {
    case high = 3
    case normal = 2
    case low = 1
}


struct Shopping: Hashable {
    var title: String
    var price: Int
    var importance: Importance
    
    let uuid = UUID()
}
