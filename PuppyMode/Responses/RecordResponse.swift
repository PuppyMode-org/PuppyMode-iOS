//
//  RecordResponse.swift
//  PuppyMode
//
//  Created by 김미주 on 06/02/2025.
//

import Foundation

struct RecordResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: RecordResult?
}

struct RecordResult: Codable {
    let message: String
    let feedImageUrl: String?
    let feedType: String
    let puppyLevel: Int
    let puppyLevelName: String
    let puppyPercent: Int
}
