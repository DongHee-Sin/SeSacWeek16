//
//  ShoppingListViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/22.
//

import Foundation


final class ShoppingListViewModel {
    
    // MARK: - Propertys
    var shoppingList: CObservable<[Shopping]> = CObservable([])
    
    
    
    
    // MARK: - Methods
    func addShopping(shopping: Shopping) {
        shoppingList.value.append(shopping)
    }
    
    func removeShopping(at index: Int) {
        shoppingList.value.remove(at: index)
    }
    
}
