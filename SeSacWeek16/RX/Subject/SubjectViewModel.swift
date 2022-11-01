//
//  SubjectViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/25.
//

import Foundation

import RxSwift
import RxCocoa


// MARK: - ViewModel 프로토콜
// associated type == generic (비슷)
// 왜 associated를 쓰는걸까?? : VM마다 Input, Output이 가지는 프로퍼티의 개수/구조가 다를 수 있기 때문
protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func transfrom(input: Input) -> Output
}


struct Contact {
    var name: String
    var age: Int
    var number: String
}


final class SubjectViewModel: CommonViewModel {
    
    // MARK: - Propertys
    var contactData = [
        Contact(name: "Jack", age: 21, number: "01012345678"),
        Contact(name: "Metaverse Jack", age: 23, number: "01012345678"),
        Contact(name: "Real Jack", age: 25, number: "01012345678")
    ]
    
    // Relay로 변경해도 된다. => onNext만 사용함..
    var list = PublishRelay<[Contact]>()
    
    
    
    
    // MARK: - Methods
    func fetchData() {
        list.accept(contactData)
    }
    
    
    func resetData() {
        list.accept([])
    }
    
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 1...50), number: "01153341352")
        contactData.append(new)
        list.accept(contactData)
    }
    
    
    func filterData(query: String) {
        let filtered = query != "" ? contactData.filter { $0.name.lowercased().contains( query.lowercased()) } : contactData
        list.accept(filtered)
    }
    
    
    
    
    // MARK: - Input / Output
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        
        let searchText: ControlProperty<String?>
    }
    
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        
        let list: Driver<[Contact]>
        
        let searchText: Observable<String>
    }
    
    func transfrom(input: Input) -> Output {
        let list = list.asDriver(onErrorJustReturn: [])
        
        let text = input.searchText.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)  // Wait
            .distinctUntilChanged()   // 같은 값을 받지 않음 (불필요한 동작(?) 방지)
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
    }
}
