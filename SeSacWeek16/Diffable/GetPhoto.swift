//
//  GetPhoto.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/22.
//

import Foundation

// MARK: - Welcome
struct GetPhoto: Codable {
    let id: String
    let width, height: Int
    let description: String
    let urls: Urls
}
