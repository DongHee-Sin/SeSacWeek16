//
//  NewsViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/20.
//

import Foundation
import RxSwift
import RxCocoa


final class NewsViewModel {
    
    // MARK: - Propertys
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    //var pageNumber: CObservable<String> = CObservable("")
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    
    //var news: CObservable<[News.NewsItem]> = CObservable(News.items)
    //var news = BehaviorSubject(value: News.items)
    var news = BehaviorRelay(value: News.items)
    
    
    
    
    // MARK: - Methods
    func changePageNumberFormat(text: String) {
        let text = text.replacingOccurrences(of: ",", with: "")
        
        guard let number = Int(text),
              let result = numberFormatter.string(for: number)
        else { return }
        
        //pageNumber.value = result
        pageNumber.onNext(text)
    }
    
    
    func resetNews() {
        //news.value = []
        //news.onNext([])
        news.accept([])
    }
    
    
    func loadNews() {
        //news.value = News.items
        //news.onNext(News.items)
        news.accept(News.items)
    }
}
