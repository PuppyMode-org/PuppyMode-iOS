//
//  KakaoLoginManager.swift
//  PuppyMode
//
//  Created by 이승준 on 1/27/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKTalk
import KakaoSDKFriendCore
import Alamofire
import UIKit

class KakaoLoginService {
    
    static func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print("UserApi.shared.loginWithKakaoAccount failed: ", error)
            } else {
                self.saveKakaoUserID()
                if let kakaoAccessToekn = oauthToken?.accessToken, let kakaoRefreshToken = oauthToken?.refreshToken {
                    print("kakaoAccessToken \(kakaoAccessToekn)")
                    print("kakaoRefreshToken \(kakaoRefreshToken)")
                    _ = saveKakaoToken(accessToken: kakaoAccessToekn, refreshToken: kakaoRefreshToken)
                    self.fetchKakaoUserInfo(with: kakaoAccessToekn, and: kakaoRefreshToken)
                }
            }
        }
    }
    
    static func fetchKakaoUserInfo(with kakaoAccessToken: String, and kakaoRefreshToken: String) {
        let fcm = KeychainService.get(key: FCMTokenKey.fcm.rawValue) ?? "none"
        print("FCM: \(fcm)")
        
        AF.request(K.String.puppymodeLink + "/auth/kakao/login",
                   method: .get,
                   parameters: ["accessToken": kakaoAccessToken,
                                "refreshToken": kakaoRefreshToken,
                                "FCMToken": fcm],
                   headers: ["accept": "*/*"])
        .responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let loginResponse):
                if UserInfoService.addUserInfoToKeychainService(userInfo: loginResponse.result) {
                    if let jwt = KeychainService.get(key: UserInfoKey.jwt.rawValue ) {
                        print("JWT: \(jwt)")
                    }
                    if loginResponse.result.userInfo.isNewUser {
                        RootViewControllerService.toPuppySelectionViewController()
                    } else {
                        RootViewControllerService.toBaseViewController()
                    }
                }
            case .failure(let error):
                print("Error LoginResponse \(K.String.puppymodeLink)/auth/kakao/login: \(error)")
            }
        }
    }
    
    static func saveKakaoToken(accessToken: String, refreshToken: String) -> Bool {
        return  KeychainService.add(key: KakaoAPIKey.kakaoAccessToken.rawValue, value: accessToken) &&
                KeychainService.add(key: KakaoAPIKey.kakaoRefreshToken.rawValue, value: refreshToken)
    }
    
    static func deleteAllKakaoToken() -> Bool {
        return  KeychainService.delete(key: KakaoAPIKey.kakaoAccessToken.rawValue) &&
                KeychainService.delete(key: KakaoAPIKey.kakaoRefreshToken.rawValue) &&
                KeychainService.delete(key: KakaoAPIKey.kakaoUserID.rawValue)
    }
    
    static func saveKakaoUserID() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                guard let kakaoUserId = user?.id else { return }
                if KeychainService.add(key: KakaoAPIKey.kakaoUserID.rawValue, value: "\(kakaoUserId)") {
                    print("kakaoUserId \(kakaoUserId)")
                }
            }
        }
    }
    
}
