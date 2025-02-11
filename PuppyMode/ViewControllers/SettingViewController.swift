//
//  SettingViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 07/01/2025.
//

import UIKit
import KakaoSDKUser
import Alamofire

class SettingViewController: UIViewController {
    
    private lazy var settingView = SettingView()
    private var revokeViewController = RevokeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        self.view = settingView
        defineButtonActions()
        getPupptInfo()
    }
}

extension SettingViewController {
    
    private func defineButtonActions() {
        self.settingView.termsOfServiceButton.addTarget(self, action: #selector(termsOfServiceButtonPressed), for: .touchUpInside)
        self.settingView.alarmSettingView.toggleView.addTarget(self, action: #selector(toggleNotification), for: .valueChanged)
        self.settingView.PrivacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonPressed), for: .touchUpInside)
        self.settingView.revokeButton.addTarget(self, action: #selector(revokeButtonPressed), for: .touchUpInside)
        self.settingView.logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
    }
    
    func setToggle() {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.jwt.rawValue)!)"
        ]
        
        AF.request(K.String.puppymodeLink + "/users/notifications",
                   method: .get,
                   headers: headers)
            .responseDecodable(of: NotificationsResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let response) :
                    self.settingView.alarmSettingView.toggleView.setOn(response.result.receiveNotifications, animated: false)
                case .failure(let error) :
                    print("Network Error: \(error.localizedDescription)")
                }
            }
    }
    
    @objc
    private func toggleNotification() {
        let isOn = self.settingView.alarmSettingView.toggleView.isOn
        let parameters: Parameters = [
            "receiveNotifications": isOn
        ]
        
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.jwt.rawValue)!)",
            "Content-Type": "application/json"
        ]
        
        AF.request(K.String.puppymodeLink + "/users/notifications",
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: NotificationsResponse.self) { response in
                switch response.result {
                case .success:
                    print("Notification Changed is Success to \(isOn)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    @objc
    private func termsOfServiceButtonPressed() {
        let viewControllerToPresent = PolicyOrTermPopoverViewController()
        viewControllerToPresent.configurePopoverView(title: "이용약관", content: K.String.policy)
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        viewControllerToPresent.modalTransitionStyle = .crossDissolve
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    @objc
    private func privacyPolicyButtonPressed() {
        let viewControllerToPresent = PolicyOrTermPopoverViewController()
        viewControllerToPresent.configurePopoverView(title: "개인정보 처리 방침", content: K.String.policy)
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        viewControllerToPresent.modalTransitionStyle = .crossDissolve
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    @objc
    private func revokeButtonPressed() {
        let viewControllerToPresent = revokeViewController
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent,animated: true)
    }
    
    @objc
    private func logoutButtonPressed() {
        let viewControllerToPresent = LogoutCheckViewController()
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        viewControllerToPresent.modalTransitionStyle = .crossDissolve
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func changeRootToLoginViewController() {
        let baseViewController = LoginViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootViewController(baseViewController, animated: false)
    }
    
    private func getPupptInfo() {
        guard let fcm = KeychainService.get(key: UserInfoKey.jwt.rawValue) else { return }
        
        AF.request( K.String.puppymodeLink + "/puppies",
                    headers: [
                        "accept": "*/*",
                        "Authorization": "Bearer " + fcm
                    ])
        .responseDecodable(of: PuppyInfoResponse.self) { response in
            switch response.result {
            case .success(let response):
                self.revokeViewController.setPuppyName(response.result.puppyName)
            case .failure(let error):
                // 강아지 정보 불러오기에 실패했습니다. 라는 알림 띄우기? (다시시도)
                print("/puppies error", error)
            }
        }
    }
}

#Preview{
    SettingViewController()
}
