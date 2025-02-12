//
//  SocialService.swift
//  PuppyMode
//
//  Created by 이승준 on 2/4/25.
//

import Alamofire
import Foundation

class SocialService {
    
    static var isFetchingGlobalRankData: Bool = false
    static var isFetchingFriendRankData: Bool = false
    static var globalRankPage: Int = 0
    static var friendRankPage: Int = 0
    static let pageSize: Int = 10
    
    static func fetchGlobalRankData(completion: (() -> Void)? = nil) {
        guard !isFetchingGlobalRankData else { return }
        guard let jwt = KeychainService.get(key: UserInfoKey.jwt.rawValue) else { return }
        
        isFetchingGlobalRankData = true
        AF.request(
            K.String.puppymodeLink + "/rankings/global?page=\(globalRankPage)&size=\(pageSize)",
            method: .get,
            headers: ["accept": "*/*",
                      "Authorization": "Bearer \(jwt)"])
        
        .responseDecodable(of: SocialRankResponse.self) { response in
            defer {
                isFetchingGlobalRankData = false
                DispatchQueue.main.async { completion?() }
            }
            
            switch response.result {
            case .success(let response):
                RankModel.globalRankData.append(contentsOf: response.result.rankings)
                RankModel.myGlobalRank = response.result.currentUserRank
                if !response.result.rankings.isEmpty { // 빈 페이지가 아니어야만 다음 페이지가 가능
                    globalRankPage += pageSize
                }
            case .failure(let error):
                print("Global fetch error: \(error)")
            }
        }
    }
    
    static func fetchFriendRankData(completion: (() -> Void)? = nil) {
        guard !isFetchingFriendRankData else { return }
        guard let jwt = KeychainService.get(key: UserInfoKey.jwt.rawValue),
              let kakaoAccessToken = KeychainService.get(key: KakaoAPIKey.kakaoAccessToken.rawValue) else { return }
        
        isFetchingFriendRankData = true
        
        AF.request(
            K.String.puppymodeLink + "/rankings/friends?accessToken=\(kakaoAccessToken)&page=\(friendRankPage)&size=\(pageSize)",
            method: .get,
            headers: ["accept": "*/*",
                      "Authorization": "Bearer \(jwt)"])
        .responseDecodable(of: SocialRankResponse.self) { response in
            defer {
                isFetchingFriendRankData = false
                DispatchQueue.main.async { completion?() } // 완료 핸들러 이동
            }
            
            switch response.result {
            case .success(let response):
                
                RankModel.friendsRankData.append(contentsOf: response.result.rankings)
                RankModel.myRankInFriends = response.result.currentUserRank
                
                if !response.result.rankings.isEmpty { // 빈 페이지가 아니어야만 다음 페이지가 가능
                    friendRankPage += pageSize
                }
                
            case .failure(let error):
                print("Friends fetch error: \(error)")
            }
        }
    }
    
    static func updateRankData(completion: (() -> Void)? = nil) {
        // 1. 0부터 현재 불러온 만큼 다시 전부 받는다. 0 ~ globalRankPage + pageSize
        // 2. RankModel.globalRankData에 바뀐 점이 있으면 그 부분을 교체한다. (순위가 바뀔 수 도 있음. 그러면 그냥 다 바꿔버리면 안됨?)
        // 3. 그냥 그럴거면, 친구랑 글로벌을 굳이 분리할 필요도 없어짐
        // 4. 언제? 1. viewWillAppear() 2. segment 변동
        // 5. global은 본인 내용도 업데이트 되어야함
        
        guard !isFetchingGlobalRankData else { return }
        guard let jwt = KeychainService.get(key: UserInfoKey.jwt.rawValue) else { return }
        guard let kakaoAccessToken = KeychainService.get(key: KakaoAPIKey.kakaoAccessToken.rawValue) else { return }
        
        isFetchingGlobalRankData = true
        AF.request(
            K.String.puppymodeLink + "/rankings/global?page=\(0)&size=\(globalRankPage + pageSize)",
            method: .get,
            headers: ["accept": "*/*",
                      "Authorization": "Bearer \(jwt)"])
        
        .responseDecodable(of: SocialRankResponse.self) { response in
            defer {
                isFetchingGlobalRankData = false
                DispatchQueue.main.async { completion?() }
            }
            
            switch response.result {
            case .success(let response):
                RankModel.globalRankData = response.result.rankings
                RankModel.myGlobalRank = response.result.currentUserRank
            case .failure(let error):
                print("Global fetch error: \(error)")
            }
        }
        
        isFetchingFriendRankData = true
        AF.request(
            K.String.puppymodeLink + "/rankings/friends?accessToken=\(kakaoAccessToken)&page=\(0)&size=\(friendRankPage + pageSize)",
            method: .get,
            headers: ["accept": "*/*",
                      "Authorization": "Bearer \(jwt)"])
        .responseDecodable(of: SocialRankResponse.self) { response in
            defer {
                isFetchingFriendRankData = false
                DispatchQueue.main.async { completion?() } // 완료 핸들러 이동
            }
            
            switch response.result {
            case .success(let response):
                
                RankModel.friendsRankData = response.result.rankings
                RankModel.myRankInFriends = response.result.currentUserRank
                
                if !response.result.rankings.isEmpty { // 빈 페이지가 아니어야만 다음 페이지가 가능
                    friendRankPage += pageSize
                }
                
            case .failure(let error):
                print("Friends fetch error: \(error)")
            }
        }
    }
    
}
