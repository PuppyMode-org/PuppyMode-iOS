//
//  DummyRankModel.swift
//  PuppyMode
//
//  Created by 이승준 on 1/21/25.
//

import UIKit

class RankModel {
    
    static var currentState: SocialState = .global

    static var myGlobalRank: RankUserInfo?
    
    static var myRankInFriends: RankUserInfo?
    
    static var globalRankData: [RankUserInfo] = []
    
    static var friendsRankData: [RankUserInfo] = []
    
    enum SocialState {
        case global, friends
    }
}
