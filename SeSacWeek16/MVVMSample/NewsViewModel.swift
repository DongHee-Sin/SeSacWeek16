//
//  NewsViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/20.
//

import Foundation


final class NewsViewModel {
    
    // MARK: - Propertys
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var pageNumber: CObservable<String> = CObservable("")
    
    var news: CObservable<[News.NewsItem]> = CObservable(News.items)
    
    
    
    
    // MARK: - Methods
    func changePageNumberFormat(text: String) {
        let text = text.replacingOccurrences(of: ",", with: "")
        
        guard let number = Int(text),
              let result = numberFormatter.string(for: number)
        else { return }
        
        pageNumber.value = result
    }
    
    
    func resetNews() {
        news.value = []
    }
    
    
    func loadNews() {
        news.value = News.items
    }
}
