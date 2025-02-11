//
//  AlcoholListResponse.swift
//  PuppyMode
//
//  Created by 김미주 on 03/02/2025.
//

import Foundation

struct AlcoholListResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: AlcoholCategoryDetail
}

struct AlcoholCategoryDetail: Codable {
    let categoryId: Int
    let categoryName: String
    let items: [AlcoholListItem]
}

struct AlcoholListItem: Codable {
    let itemId: Int
    let itemName: String
    let alcoholPercentage: Double
    let volumeMl: Int?
    let imageUrl: String?
    var categoryId: Int?
}
