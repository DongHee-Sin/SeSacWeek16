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
    
    
    typealias SearchPhotoHandler = (SearchPhoto?, Int?, Error?) -> Void
    typealias GetPhotoHandler = ([GetPhoto]?, Int?, Error?) -> Void
    
    
    static func searchPhoto(query: String, completion: @escaping SearchPhotoHandler) {
        
        let url = APIKey.searchURL + query
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value):
                completion(value, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
            
        }
        
    }
    
    
    static func getPhoto(id: String, completion: @escaping GetPhotoHandler) {
        
        let url = APIKey.getURL
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        let param: Parameters = ["id": id]
        
        AF.request(url, method: .get, parameters: param, headers: header).responseDecodable(of: [GetPhoto].self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
    }
}
