//
//  CalendarDateView.swift
//  PuppyMode
//
//  Created by 김미주 on 09/02/2025.
//

import UIKit

class CalendarDateView: UIView {

    // MARK: - layout
    // 배경
    public let backView = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.cornerRadius = 30
        $0.layer.borderWidth = 1.49
        $0.layer.borderColor = UIColor(red: 0.877, green: 0.877, blue: 0.877, alpha: 1).cgColor
    }
    
    // 날짜
    public let dateLabel = UILabel().then {
        $0.text = "2000.00.00"
        $0.textColor = UIColor(red: 0.34, green: 0.34, blue: 0.34, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 16)
    }
    
    // 날
    public let dayLabel = UILabel().then {
        $0.text = "건강 챙긴 날"
        $0.textColor = UIColor(red: 0.34, green: 0.34, blue: 0.34, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    // 음주 기록
    private let recordLabel = UILabel().then {
        $0.text = "음주 기록"
        $0.textColor = UIColor(red: 0.34, green: 0.34, blue: 0.34, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
    }
    
    private let recordButton = CalendarDateCustomButton()
    
    // 술 약속
    private let appointmentLabel = UILabel().then {
        $0.text = "술 약속"
        $0.textColor = UIColor(red: 0.34, green: 0.34, blue: 0.34, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
    }
    
    private let appointmentButton = CalendarDateCustomButton()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - function
    private func setView() {
        [
            backView,
            dateLabel, dayLabel,
            recordLabel, recordButton,
            appointmentLabel, appointmentButton
        ].forEach {
            addSubview($0)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(50)
        }
        
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.left.equalTo(dateLabel.snp.left)
        }
        
        recordLabel.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(30)
            $0.left.equalTo(recordButton.snp.left).offset(13)
        }
        
        recordButton.snp.makeConstraints {
            $0.top.equalTo(recordLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(80)
        }
        
        appointmentLabel.snp.makeConstraints {
            $0.top.equalTo(recordButton.snp.bottom).offset(15)
            $0.left.equalTo(appointmentButton.snp.left).offset(13)
        }
        
        appointmentButton.snp.makeConstraints {
            $0.top.equalTo(appointmentLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(80)
        }
    }
}
