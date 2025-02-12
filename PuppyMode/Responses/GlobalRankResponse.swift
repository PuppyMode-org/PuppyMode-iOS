//
//  SocialAllRankResponse.swift
//  PuppyMode
//
//  Created by 이승준 on 2/4/25.
//

import Foundation

struct GlobalRankResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: GlobalUserResponse
}

struct GlobalUserResponse: Codable {
    let currentUserRank: UserRankInfo
    let rankings: [UserRankInfo]
    let totalCount: Int
}

struct UserRankInfo: Codable {
    let rank : Int
    let username: String
    let puppyName: String?
    let level: Int
    let levelName: String
    let imageUrl: URL?
}
