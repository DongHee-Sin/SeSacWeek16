//
//  DiffableViewModel.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/20.
//

import Foundation


final class DiffableViewModel {
    
    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { photo, statusCode, error in
            guard let photo else { return }
            self.photoList.value = photo
        }
    }
    
    func requestPhotoInfo(at index: Int) {
        let id = fetchPhotoID(at: index)
    }
    
    func fetchPhotoID(at index: Int) -> String {
        return photoList.value.results[index].id
    }
    
}
