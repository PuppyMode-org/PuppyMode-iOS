//
//  AlcoholKindResponse.swift
//  PuppyMode
//
//  Created by 김미주 on 03/02/2025.
//

import Foundation

struct AlcoholCategoryResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [AlcoholCategory]
}

struct AlcoholCategory: Codable {
    let categoryId: Int
    let categoryName: String
}
