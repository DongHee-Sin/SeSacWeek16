//
//  APIService.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/20.
//

import Foundation
import Alamofire


final class APIService {
    
    private init() {}
    
    
    typealias CompletionHandler = (SearchPhoto?, Int?, Error?) -> Void
    
    
    static func searchPhoto(query: String, completion: @escaping CompletionHandler) {
        
        let url = APIKey.searchURL + query
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case let .success(value):
                completion(value, statusCode, nil)
            case let .failure(error):
                completion(nil, statusCode, error)
            }
            
        }
        
    }
}
