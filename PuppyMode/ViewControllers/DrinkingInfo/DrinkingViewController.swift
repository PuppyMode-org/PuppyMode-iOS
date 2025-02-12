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
        
        drinkingView.promiseButton.addTarget(self, action: #selector(didTapPromiseButton), for: .touchUpInside)
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

    @objc private func didTapPromiseButton() {
       print("Promise button tapped!")
        // Create a container view for the picker and toolbar
        let pickerContainerView = UIView()
        pickerContainerView.backgroundColor = UIColor.white
        pickerContainerView.layer.cornerRadius = 10
        pickerContainerView.clipsToBounds = true
        
        
        // Create UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        pickerContainerView.addSubview(datePicker)
        
        // Create Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Customizing the toolbar appearance
        toolbar.barTintColor = UIColor(hex: "#FFFFFF") // Toolbar 배경색
        toolbar.tintColor = UIColor(hex: "#3C3C3C")   // 버튼 텍스트 색상
        
        // Toolbar buttons
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelPicker))
        cancelButton.setTitleTextAttributes([.font: UIFont(name: "NotoSansKR-Medium", size: 14)!], for: .normal)
        
        let confirmButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(didTapConfirmPicker))
        confirmButton.setTitleTextAttributes([.font: UIFont(name: "NotoSansKR-Medium", size: 14)!], for: .normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, flexibleSpace, confirmButton], animated: false)
        
        pickerContainerView.addSubview(toolbar)
        
        // Add to the main view
        view.addSubview(pickerContainerView)
        
        // Layout for pickerContainerView
        pickerContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300) // Adjust height as needed
            make.bottom.equalTo(self.view.snp.bottom).offset(300) // Start below the screen
        }
        
        // Layout for datePicker
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(216) // Standard height for UIDatePicker
        }
        
        // Layout for toolbar
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(datePicker.snp.top).offset(-10)
            make.height.equalTo(44) // Standard height for toolbar
        }
        
        // Animate Picker Container View to slide up from the bottom
        UIView.animate(withDuration: 0.3) {
            pickerContainerView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom) // Move to the bottom of the screen (visible)
            }
            self.view.layoutIfNeeded() // Apply layout changes immediately during animation
        }
    }
    
    @objc private func didTapCancelPicker() {
        guard let pickerContainerView = view.subviews.last else { return }

            UIView.animate(withDuration: 0.3, animations: {
                pickerContainerView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.snp.bottom).offset(300) // Slide down below the screen
                }
                self.view.layoutIfNeeded() // Apply layout changes immediately during animation
            }) { _ in
                pickerContainerView.removeFromSuperview() // Remove from superview after animation completes
           }
    }

    @objc private func didTapConfirmPicker() {
        guard let pickerContainerView = view.subviews.last as? UIView,
              let datePicker = pickerContainerView.subviews.compactMap({ $0 as? UIDatePicker }).first else { return }
        
        // 선택된 시간 가져오기
        let selectedTime = datePicker.date
        
        // Format the selected time to ISO8601 format for the API request
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        let formattedDateTime = formatter.string(from: selectedTime)
        
        print("선택된 시간:", formattedDateTime)
        
        // Picker를 닫습니다.
        pickerContainerView.removeFromSuperview()
        
        // API 요청 보내기
        sendRescheduleRequest(appointmentId: appointmentId, dateTime: formattedDateTime)
    }
    
    // MARK: Connect Api
    // 술 약속 및 음주 상태 조회하기 API
    private func checkDrinkingStatus() {
        let authToken = KeychainService.get(key: UserInfoKey.jwt.rawValue) ?? ""
        
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
    
    private func updateDrinkingView(with result: DrinkingStatusResult?) {
        guard let result = result else { return }
        
        // progressNameLabel 업데이트
        drinkingView.progressNameLabel.text = "\(result.puppyName)가 지켜보고 있어요!"
        
        // progressTimeLabel 업데이트
        drinkingView.progressTimeLabel.text = "\(result.drinkingHours)시간 째 술마시는 중"
    }
    
    // 술 약속 미루기 API
    private func sendRescheduleRequest(appointmentId: Int, dateTime: String) {
        guard let authToken = KeychainService.get(key: UserInfoKey.jwt.rawValue) else {
            print("인증 토큰을 가져올 수 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        let parameters: [String: Any] = [
            "dateTime": dateTime
        ]
        
        let url = "\(K.String.puppymodeLink)/appointments/\(appointmentId)"
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseDecodable(of: RescheduleAppointmentResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.code == "SUCCESS_PUT_APPOINTMENT_RESCHEDULED" {
                        print("술 약속 수정 성공!")
                        
                        // 모달 창 표시
                        self.showSuccessModal(message: data.result?.message ?? "술 약속이 성공적으로 수정되었습니다.")
                    } else {
                        print("응답 코드가 SUCCESS_PUT_APPOINTMENT_RESCHEDULED가 아닙니다.")
                        self.showSuccessModal(message: data.result?.message ?? "술 약속 수정에 실패하였습니다.")
                    }
                case .failure(let error):
                    print("API 요청 실패:", error.localizedDescription)
                }
            }
    }

    // 술 약속 미루기 결과 모달 창
    private func showSuccessModal(message: String) {
        let alertController = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 음주 상태 종료하기 API
    @objc private func didTapEndButton() {
        print("End button tapped!")
        
        guard let authToken = KeychainService.get(key: UserInfoKey.jwt.rawValue) else {
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
