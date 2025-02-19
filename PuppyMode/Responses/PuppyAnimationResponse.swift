//
//  PuppyAnimationResponse.swift
//  PuppyMode
//
//  Created by 김민지 on 2/13/25.
//
import Foundation

struct PuppyAnimationParameter: Encodable {
    let animationType: String
}

struct PuppyAnimationResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PuppyAnimationResult
}

struct PuppyAnimationResult: Decodable {
    let animationType: String
    let frameCount: Int
    let imageUrls: [String]
}
