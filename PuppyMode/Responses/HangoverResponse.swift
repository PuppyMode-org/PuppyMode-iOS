//
//  HangoverModel.swift
//  PuppyMode
//
//  Created by 김미주 on 17/01/2025.
//

import Foundation

struct HangoverResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [HangoverModel]
}

struct HangoverModel: Decodable {
    let hangoverId: Int
    let hangoverName: String
    let imageUrl: String?
}
