//
//  HomeViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 07/01/2025.
//

import UIKit
import CoreLocation // 현재 위치 확인
import Alamofire

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    private var timer: Timer?
    private var remainingTime: Int = 1800 // 30분 (초 단위)
    public var coinAlermButton = AlermView()
    
    private let locationManager = CLLocationManager()
    private var currentLatitude: Double?    // 위도 정보
    private var currentLongitude: Double?   // 경도 정보
    
    public var appointmentId: Int?   // 현재 가장 가까운 약속 id

    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        self.view = homeView
        self.navigationController?.isNavigationBarHidden = true
        
        setupLocationManager()
        self.defineButtonActions()
        
        // 가장 가까운 약속 확인 및 시작
        checkClosestAppointment { appointmentId in
            guard let appointmentId = appointmentId else {
                print("가장 가까운 약속 ID를 가져올 수 없습니다.")
                return
            }
            
            // 약속 시작 API 호출
            self.startAppointment(appointmentId: appointmentId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPupptInfo()
    }
    
    // 위치 매니저 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // 권한 요청
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation() // 위치 업데이트 시작
        } else {
            print("위치 서비스가 비활성화되어 있습니다.")
        }
    }
    
    // 위치 정보 사용 동의 여부
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("위치 접근이 허용되었습니다.")
            locationManager.startUpdatingLocation()
        case .denied:
            print("위치 접근이 거부되었습니다. 설정에서 변경해야 합니다.")
        case .restricted:
            print("위치 접근이 제한되었습니다.")
        case .notDetermined:
            print("위치 접근 상태가 결정되지 않았습니다.")
        @unknown default:
            break
        }
    }
    
    // CLLocationManagerDelegate - 위치 업데이트 시 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
        print("현재 위치 - 위도: \(currentLatitude ?? 0), 경도: \(currentLongitude ?? 0)")
        
        // 위치 업데이트 중지 (필요 시 한 번만 가져오기)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져오지 못했습니다: \(error.localizedDescription)")
    }
}


//MARK: GET Puppy Character Info
extension HomeViewController {
        
    func getPupptInfo() {
        guard let fcm = KeychainService.get(key: UserInfoKey.jwt.rawValue) else { return }
        
        AF.request( K.String.puppymodeLink + "/puppies",
                    headers: [
                        "accept": "*/*",
                        "Authorization": "Bearer " + fcm
                    ])
        .responseDecodable(of: PuppyInfoResponse.self) { response in
            switch response.result {
            case .success(let response):
                let puppyInfo = response.result
                print(puppyInfo)
                self.homeView.configurePuppyInfo(to: puppyInfo)
            case .failure(let error):
                // 강아지 정보 불러오기에 실패했습니다. 라는 알림 띄우기? (다시시도)
                print("/puppies error", error)
            }
        }
    }
    
}

//MARK: Add Button Actions
extension HomeViewController {
    private func defineButtonActions() {
        self.homeView.decorationButton.addTarget(self, action: #selector(decorationButtonPressed), for: .touchUpInside)
        self.homeView.rompingButton.addTarget(self, action: #selector(rompingButtonPressed), for: .touchUpInside)
        self.homeView.collectionButton.addTarget(self, action: #selector(collectionPressed), for: .touchUpInside)
        self.homeView.puppyImageButton.addTarget(self, action: #selector(puppyImagePressed), for: .touchUpInside)
        self.homeView.drinkingCapacityButton.addTarget(self, action: #selector(drinkingCapacityButtonPressed), for: .touchUpInside)
        self.homeView.addDrinkingHistoryButton.addTarget(self, action: #selector(addDrinkingHistoryButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func decorationButtonPressed() {
        let decoVC = DecoViewController()
        decoVC.hidesBottomBarWhenPushed = true  // 탭바 숨기기 설정
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(decoVC, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: decoVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // 놀아주기 버튼 클릭시
    @objc
    private func rompingButtonPressed() {
        print("Romping Button Pressed")
        // 서버 연동
        rompingToServer()
        
        // 강아지 애니메이션 효과
        showDogAnimation()
        
        // 포인트 휙득 알림 표시 (10P)
        showPointAlert()
        
        // 버튼 비활성화 & 타이머 시작
        startCooldown()
        
    }
    
    @objc
    private func collectionPressed() {
        let collectionVC = CollectionViewController()
        collectionVC.hidesBottomBarWhenPushed = true
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(collectionVC, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: collectionVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @objc
    private func puppyImagePressed() {
        print("Puppy Image Button Pressed")
    }
    
    // 주량 확인 페이지 이동 함수
    @objc private func drinkingCapacityButtonPressed() {
        print("Drinking Capacity Button Pressed")
        
        let drinkingInfoVC = DrinkingInfoViewController()
        drinkingInfoVC.hidesBottomBarWhenPushed = true  // 탭 바 숨기기 설정
        
        // 네비게이션 컨트롤러를 통해 화면 전환
        if let navigationController = self.navigationController {
            navigationController.pushViewController(drinkingInfoVC, animated: true)
        } else {
            // 네비게이션 컨트롤러가 없으면 새로 생성하여 표시
            let navController = UINavigationController(rootViewController: drinkingInfoVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @objc
    private func addDrinkingHistoryButtonPressed() {
        print("Add Drinking History Button Pressed")
        
        // 버튼의 title을 확인
        let buttonTitle = homeView.addDrinkingHistoryButton.getTitleLabel()
        
        if buttonTitle == "음주 기록" {
            // 음주 기록 화면으로 이동
            let hangoverVC = HangoverViewController()
            self.navigationController?.isNavigationBarHidden = true
            hangoverVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hangoverVC, animated: true)
            
        } else if buttonTitle == "술 마시는 중..." {
            // 음주 중 화면으로 이동
            checkClosestAppointment { appointmentId in
                guard let appointmentId = appointmentId else {
                    print("가장 가까운 약속 ID를 가져올 수 없습니다.")
                    return
                }
                
                let drinkingVC = DrinkingViewController(appointmentId: appointmentId) // appointmentId 전달
                
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(drinkingVC, animated: true)
                } else {
                    let navController = UINavigationController(rootViewController: drinkingVC)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true, completion: nil)
                }
            }
        } else {
            print("알 수 없는 버튼 상태입니다.")
        }
    }
}

// 놀아주기 버튼에 대한 함수
extension HomeViewController {
    
    // 서버 연동
    private func rompingToServer() {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.jwt.rawValue)!)"
        ]
        
        AF.request(K.String.puppymodeLink + "/puppies/play",
                   method: .post,
                   headers: headers)
        .responseDecodable(of: PuppyPlayResponse.self) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result {
            case .success(let puppyResponse) :
                if puppyResponse.isSuccess {
                    print("놀아주기 서버 연동 성공")
                    print("성공")
                    getPupptInfo()
                } else {
                    print("Puppy Play API Error: \(puppyResponse.message)")
                }
            case .failure(let error) :
                print("Network Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func showDogAnimation() {
        
    }
    
    private func showPointAlert() {
        // 알림 버튼 위치 설정
        self.view.addSubview(coinAlermButton)
        coinAlermButton.coinLabel.text = "10P 휙득 !"
        
        coinAlermButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(59)
        }
        
        // 알림 버튼 5초 후에 사라지게 설정
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.coinAlermButton.removeFromSuperview()
        }
    }
    
    private func startCooldown() {
        homeView.rompingButton.isEnabled = false
        homeView.rompingButton.alpha = 0.5
        homeView.countdownLabel.alpha = 1
        homeView.countdownLabel.text = "30:00"
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            homeView.countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            resetButton()
        }
    }
    
    // 30분 후 버튼 활성화
    private func resetButton() {
        timer?.invalidate()
        timer = nil
        
        homeView.countdownLabel.alpha = 0
        homeView.rompingButton.isEnabled = true
        homeView.rompingButton.alpha = 1
        
    }
}


// MARK: - 음주 중인지 아닌지 체크
extension HomeViewController {
    // 가장 가까운 약속 ID 확인 API 호출
    private func checkClosestAppointment(completion: @escaping (Int?) -> Void) {
        let authToken = KeychainService.get(key: UserInfoKey.jwt.rawValue) ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        AF.request(K.String.puppymodeLink + "/appointments",
                   method: .get,
                   headers: headers)
            .responseDecodable(of: GetAppointmentsResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.code == "SUCCESS_GET_APPOINTMENTS" {
                        print("술 약속 조회 성공!")
                        
                        // 가장 가까운 약속 ID 추출 및 반환
                        if let closestAppointmentId = self.getClosestScheduledAppointment(from: data.result?.appointments ?? []) {
                            print("가장 가까운 약속 ID:", closestAppointmentId)
                            completion(closestAppointmentId)
                        } else {
                            print("현재 예정된 약속이 없습니다.")
                            completion(nil)
                        }
                    } else {
                        print("응답 코드가 SUCCESS_GET_APPOINTMENTS가 아닙니다.")
                        completion(nil)
                    }
                case .failure(let error):
                    print("API 요청 실패:", error.localizedDescription)
                    completion(nil)
                }
            }
    }

    
    // 가장 가까운 scheduled 상태의 약속 ID 추출 함수
    private func getClosestScheduledAppointment(from appointments: [Appointment]) -> Int? {
        let currentDate = Date()
        
        // scheduled 상태의 약속만 필터링
        let scheduledAppointments = appointments.filter { $0.status.lowercased() == "scheduled" }
        
        // 가장 가까운 날짜 및 시간의 약속 찾기
        let closestAppointment = scheduledAppointments.min(by: { appointment1, appointment2 in
            guard let date1 = appointment1.dateTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss"),
                  let date2 = appointment2.dateTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss") else { return false }
            
            return abs(date1.timeIntervalSince(currentDate)) < abs(date2.timeIntervalSince(currentDate))
        })
        
        return closestAppointment?.appointmentId
    }
    
    // 술 약속 시작하기 API --> 시작 성공 시 버튼 기능 변경, 시작 실패 시 주량 기록으로 유지
    private func startAppointment(appointmentId: Int) {
        guard let latitude = currentLatitude, let longitude = currentLongitude else {
            print("위치 정보를 가져올 수 없습니다.")
            return
        }
        
        let fcmToken = KeychainService.get(key: UserInfoKey.jwt.rawValue) ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(fcmToken)"
        ]
        
        let parameters: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude
        ]
        
        let url = "\(K.String.puppymodeLink)/appointments/\(appointmentId)/start"
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseDecodable(of: StartAppointmentResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.code == "SUCCESS_START_APPOINTMENT" {
                        print("술 약속 시작 성공!")
                        
                        DispatchQueue.main.async {
                            self.homeView.addDrinkingHistoryButton.setTitleLabel(to: "술 마시는 중...")
                            self.homeView.addDrinkingHistoryButton.setSubTitleLabel(to: "")
                        }
                        
                    } else {
                        print("응답 코드가 SUCCESS_START_APPOINTMENT가 아닙니다.")
                        
                        DispatchQueue.main.async {
                            self.homeView.addDrinkingHistoryButton.setTitleLabel(to: "음주 기록")
                            self.homeView.addDrinkingHistoryButton.setSubTitleLabel(to: "술 마셨어요")
                        }
                    }
                case .failure(let error):
                    print("API 요청 실패:", error.localizedDescription)
                }
            }
    }

}

import SwiftUI
#Preview {
    HomeViewController()
}
