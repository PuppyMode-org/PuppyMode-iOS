//
//  DatePickerModalViewController.swift
//  PuppyMode
//
//  Created by 박준석 on 2/13/25.
//

import UIKit
import SnapKit

class DatePickerModalViewController: UIViewController {
    
    // MARK: - Properties
    var onTimeSelected: ((String) -> Void)? // 시간 선택 콜백
    
    private let datePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
        $0.backgroundColor = UIColor.white
    }
    
    private let navBar = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    private let confirmButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        
        self.view.backgroundColor = UIColor.white
        
        // 화면 크기 조정을 위한 설정 (iOS 15 이상)
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()] // 중간 크기만 제공
            sheet.prefersGrabberVisible = true // 드래그 바 표시
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false // 스크롤 확장 비활성화
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(navBar)
        navBar.addSubview(cancelButton)
        navBar.addSubview(confirmButton)
        
        view.addSubview(datePicker)
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(navBar)
            make.height.equalTo(30)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(navBar)
            make.height.equalTo(30)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(150) // DatePicker 높이 설정
        }
    }
    
    // MARK: - Button Actions
    @objc private func didTapCancel() {
        self.dismiss(animated: true, completion: nil) // 화면 닫기
    }
    
    @objc private func didTapConfirm() {
        let now = Date() // 현재 시간
        let selectedDate = datePicker.date // 선택된 시간
        
        // 선택된 시간이 현재 시간보다 이전인지 확인
        if selectedDate < now {
            // Alert 창 표시
            let alert = UIAlertController(title: "오류",
                                          message: "현재 시간 이후로 시간을 설정해주세요.",
                                          preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
            return // Confirm 동작 중단
        }
        
        // 선택된 시간이 유효한 경우 Confirm 처리
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm" // 오전/오후 hh:mm 형식
        let selectedTime = formatter.string(from: selectedDate)
        
        onTimeSelected?(selectedTime) // 선택된 시간 전달
        self.dismiss(animated: true, completion: nil) // 화면 닫기
    }
}
