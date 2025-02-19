//
//  DrinkingViewController.swift
//  PuppyMode
//
//  Created by 박준석 on 1/24/25.
//

import UIKit
import Alamofire

class DrinkingViewController: UIViewController {

    private let drinkingView = DrinkingView()
    private var appointmentId: Int // 전달받은 appointmentId 저장
    
    init(appointmentId: Int) {
        self.appointmentId = appointmentId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = drinkingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        checkDrinkingStatus()
        
        drinkingView.endButton.addTarget(self, action: #selector(didTapEndButton), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        self.title = "술 마시는 중"
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal) // Use SF Symbols or your own image asset.
        backButton.tintColor = UIColor.black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
    }

    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Connect Api
    // 술 약속 및 음주 상태 조회하기 API
    private func checkDrinkingStatus() {
        let authToken = KeychainService.get(key: UserInfoKey.accessToken.rawValue) ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        let url = "\(K.String.puppymodeLink)/appointments/\(appointmentId)/status" // appointmentId는 전달받은 값
        
        AF.request(url,
                   method: .get,
                   headers: headers)
        .responseDecodable(of: CheckDrinkingStatusResponse.self) { response in
            switch response.result {
            case .success(let data):
                if data.code == "SUCCESS_GET_APPOINTMENT_STATUS" {
                    print("술 약속 및 음주 상태 조회 성공!")
                    
                    // 뷰 업데이트
                    DispatchQueue.main.async {
                        self.updateDrinkingView(with: data.result)
                    }
                } else {
                    print("응답 코드가 SUCCESS_GET_APPOINTMENT_STATUS가 아닙니다.")
                }
            case .failure(let error):
                print("API 요청 실패:", error.localizedDescription)
            }
        }
    }
    
    // 음주 상태 현황 label 업데이트 함수
    private func updateDrinkingView(with result: DrinkingStatusResult?) {
        guard let result = result else { return }
        
        // progressNameLabel 업데이트
        drinkingView.progressNameLabel.text = "\(result.puppyName)가 지켜보고 있어요!"
        
        // progressTimeLabel 업데이트
        drinkingView.progressTimeLabel.text = "\(result.drinkingHours)시간 째 술마시는 중"
    }
    
    // 음주 상태 종료하기 API
    @objc private func didTapEndButton() {
        print("End button tapped!")
        
        guard let authToken = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else {
            print("인증 토큰을 가져올 수 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        // PATCH 요청 URL
        let url = "\(K.String.puppymodeLink)/appointments/\(appointmentId)/status"
        
        // 요청 본문 (음주 상태 종료)
        let parameters: [String: Any] = [
            "status": "COMPLETED" // 상태를 COMPLETED로 변경
        ]
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: EndAppointmentResponse.self) { response in
            switch response.result {
            case .success(let data):
                if data.code == "SUCCESS_END_DRINKING_APPOINTMENT" {
                    print("음주 상태 종료 성공!")
                    
                    // 음주 종료 시간 출력
                    if let completedTime = data.result?.completedTime {
                        print("음주 종료 시점: \(completedTime)")
                    }
                    
                    // EndDrinkingViewController로 이동
                    DispatchQueue.main.async {
                        let endDrinkingVC = EndDrinkingViewController()
                        endDrinkingVC.modalPresentationStyle = .fullScreen
                        self.present(endDrinkingVC, animated: true, completion: nil)
                    }
                } else {
                    print("응답 코드가 SUCCESS_END_DRINKING_APPOINTMENT가 아닙니다.")
                }
            case .failure(let error):
                print("API 요청 실패:", error.localizedDescription)
            }
        }
    }
    
}
