//
//  DecorationItemModel.swift
//  PuppyMode
//
//  Created by 김민지 on 1/19/25.
//

import UIKit
import Foundation

// 아이템 카테고리
struct itemKey {
    static let tags = ["모자", "옷", "바닥", "집", "장난감"]
    
}

// 강아지 레벨
enum DogLevel: Int {
    case level1 = 1, level2, level3
}


struct CategoryModel {
    let categoryId: Int
    let items: [DecoItemModel]
}

// struct이면 해당 값을 업데이트한 후 다시 저장하는 방식이 필요
// class면 바로 수정 가능
class DecoItemModel {
    let itemId: Int
    let image: UIImage?
    let price: String
    var isPurchased: Bool
    var mission_item: Bool
    var isWeared: Bool

    
    init(itemId: Int, image: UIImage?, price: String, isPurchased: Bool, mission_item: Bool, isWeared: Bool) {
        self.itemId = itemId
        self.image = image
        self.price = price
        self.isPurchased = isPurchased
        self.mission_item = mission_item
        self.isWeared = isWeared
     }

    
    // itemID에 따른 아이템 이미지를 가져오는 함수
    static func getImageByID(for itemId: Int) -> UIImage? {
        for category in [DecoItemModel.hatData, DecoItemModel.clothesData, DecoItemModel.floorData, DecoItemModel.houseData, DecoItemModel.toyData].flatMap({ $0 }) {
            if let item = category.items.first(where: { $0.itemId == itemId }) {
                return item.image
            }
        }
        return nil
    }
}


extension DecoItemModel {
    static let allCategoryData: [CategoryModel] = hatData + clothesData + floorData + houseData + toyData
    // 모자
    static let hatData: [CategoryModel] = [
        CategoryModel(categoryId: 1, items: [
            DecoItemModel(itemId: 1, image: UIImage(named: "머리 위에 무지개"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 2, image: UIImage(named: "머리 위에 별 하나"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 3, image: UIImage(named: "머리 위에 별 세개"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 4, image: UIImage(named: "돌 모자"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 5, image: UIImage(named: "판다 머리띠"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            ])
    ]
    
    // 옷
    static let clothesData: [CategoryModel] = [
        CategoryModel(categoryId: 2, items: [
            DecoItemModel(itemId: 6, image: UIImage(named: "붕대"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 7, image: UIImage(named: "밴드"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 8, image: UIImage(named: "이불"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 9, image: UIImage(named: "명품 강아지 옷"), price: "500P", isPurchased: false, mission_item: false, isWeared: false),
            DecoItemModel(itemId: 10, image: UIImage(named: "하늘색 체크 옷"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            ])
    ]
    
    // 바닥
    static let floorData: [CategoryModel] = [
        CategoryModel(categoryId: 3, items: [
            DecoItemModel(itemId: 11, image: UIImage(named: "별 다섯개 짜리 돌침대"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 12, image: UIImage(named: "좌변기"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 13, image: UIImage(named: "핑크 집"), price: "1500P", isPurchased: false, mission_item: false, isWeared: false),
            DecoItemModel(itemId: 14, image: UIImage(named: "산타 집"), price: "1500P", isPurchased: false, mission_item: false, isWeared: false),
            DecoItemModel(itemId: 15, image: UIImage(named: "텐트"), price: "1500P", isPurchased: false, mission_item: false, isWeared: false),
            DecoItemModel(itemId: 16, image: UIImage(named: "박스"), price: "", isPurchased: false, mission_item: true, isWeared: false)
            ])
    ]

    // 집
    static let houseData: [CategoryModel] = [
        CategoryModel(categoryId: 4, items: [
            DecoItemModel(itemId: 17, image: UIImage(named: "무지개 카페트"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 18, image: UIImage(named: "무지개 바다"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 19, image: UIImage(named: "코타츠"), price: "1000P", isPurchased: false, mission_item: false, isWeared: false),
            DecoItemModel(itemId: 20, image: UIImage(named: "코타츠2"), price: "1000P", isPurchased: false, mission_item: false, isWeared: false),
            DecoItemModel(itemId: 21, image: UIImage(named: "귀여운 러그"), price: "1000P", isPurchased: false, mission_item: false, isWeared: false),
            DecoItemModel(itemId: 22, image: UIImage(named: "정수기 생수통"), price: "", isPurchased: false, mission_item: true, isWeared: false)
            ])
        ]

    // 장난감
    static let toyData: [CategoryModel] = [
        CategoryModel(categoryId: 5, items: [
            DecoItemModel(itemId: 23, image: UIImage(named: "두루마리 휴지"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 24, image: UIImage(named: "소화제"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 25, image: UIImage(named: "링거"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 26, image: UIImage(named: "소주병"), price: "", isPurchased: false, mission_item: true, isWeared: false),
            DecoItemModel(itemId: 27, image: UIImage(named: "1.5L 생수병"), price: "", isPurchased: false, mission_item: true, isWeared: false)
        ])
    ]
}
