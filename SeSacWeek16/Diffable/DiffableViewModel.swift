//
//  DiffableViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/20.
//

import Foundation
import RxSwift


enum SearchError: Error {
    case noPhoto
    case serverError
}


final class DiffableViewModel {
    
    //var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    var photoList = PublishSubject<SearchPhoto>()
    
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            guard let statusCode, statusCode == 200 else {
                self?.photoList.onError(SearchError.serverError)
                return
            }
            
            guard let photo else {
                self?.photoList.onError(SearchError.noPhoto)
                return
            }
            
            //self?.photoList.value = photo
            self?.photoList.onNext(photo)
//            self?.photoList.onCompleted()   ==> 만들기 나름 / 데이터 검색이 성공한 후, 당분간 검색을 할 필요가 없다면..
        }
    }
    
    func requestPhotoInfo(at index: Int) {
        let id = fetchPhotoID(at: index)
    }
    
    func fetchPhotoID(at index: Int) -> String {
        //return photoList.value.results[index].id
        return ""
    }
    
}
