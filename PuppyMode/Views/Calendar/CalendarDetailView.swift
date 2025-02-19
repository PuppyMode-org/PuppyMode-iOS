//
//  CalendarDetailView.swift
//  PuppyMode
//
//  Created by 김미주 on 28/01/2025.
//

import UIKit
import Then
import SnapKit

class CalendarDetailView: UIView {
    // MARK: - view
    // MARK: - 상단
    // 뒤로가기
    public let backButton = UIButton().then {
        $0.setImage(.iconBack, for: .normal)
    }
    
    // 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "음주 달력"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    // 날짜
    public let dateLabel = UILabel().then {
        $0.text = "2000.00.00"
        $0.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
    }
    
    // 구분선
    private let lineView = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1).cgColor
    }
    
    // 스크롤뷰
    public let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    // MARK: - 섭취량
    // 배경
    public let intakeBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }
    
    private let backgroundLine = UIView().then {
        $0.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1)
    }
    
    // 섭취량
    private let intakeLabel = UILabel().then {
        $0.text = "섭취량"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 18)
    }
    
    public let progressView = UIProgressView().then {
        $0.progressTintColor = .main
        $0.trackTintColor = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10.5
        $0.subviews[1].clipsToBounds = true
        $0.layer.sublayers?[1].cornerRadius = 10.5
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
        
        $0.progress = 0.3
    }
    
    // 안전주량
    private let safeLabel = UILabel().then {
        $0.text = "안전주량"
        $0.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
    }
    
    private let safePointImage = UIImageView().then {
        $0.image = .imgProgressPointer
    }
    
    // 치사량
    private let deadLabel = UILabel().then {
        $0.text = "치사량"
        $0.textColor = UIColor(red: 1, green: 0.327, blue: 0.327, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
    }
    
    private let deadPointImage = UIImageView().then {
        $0.image = .imgProgressPointer
    }
    
    // 테이블뷰
    public let alcoholTableView = UITableView().then {
        $0.register(CalendarAlcoholTableViewCell.self, forCellReuseIdentifier: CalendarAlcoholTableViewCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    // MARK: - 겪은 숙취
    // 배경
    public let hangoverBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }
    
    // 타이틀
    public let hangoverTitleLabel = UILabel().then {
        $0.text = "겪은 숙취"
        $0.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 14.25)
    }
    
    // 테이블뷰
    public let hangoverTableView = UITableView().then {
        $0.register(CalendarHangoverTableViewCell.self, forCellReuseIdentifier: CalendarHangoverTableViewCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    // MARK: - 획득한 먹이
    // 배경
    public let feedBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }
    
    // 타이틀
    private let feedTitleLabel = UILabel().then {
        $0.text = "획득한 먹이"
        $0.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 14.25)
    }
    
    // 먹이 이름
    public let feedLabel = UILabel().then {
        $0.text = "먹이"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 14.9)
    }
    
    // 먹이 이미지
    public let feedImage = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - function
    private func setView() {
        setScrollView()
        
        [
            backButton,
            titleLabel,
            dateLabel,
            lineView,
            scrollView
        ].forEach {
            addSubview($0)
        }
        
        // MARK: - 상단
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.left.equalToSuperview().offset(37)
            $0.width.equalTo(13)
            $0.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(45)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setScrollView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [
            intakeBackgroundView, backgroundLine,
            intakeLabel, progressView,
            safeLabel, safePointImage,
            deadLabel, deadPointImage,
            alcoholTableView,
            hangoverBackgroundView, hangoverTitleLabel, hangoverTableView,
            feedBackgroundView, feedTitleLabel, feedLabel, feedImage
        ].forEach {
            contentView.addSubview($0)
        }
        
        // MARK: - 섭취량
        intakeBackgroundView.snp.makeConstraints {
            $0.top.equalTo(scrollView).offset(4)
            $0.horizontalEdges.equalTo(scrollView).inset(20)
        }
        
        backgroundLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(intakeBackgroundView)
            $0.top.equalTo(intakeBackgroundView.snp.top).offset(170)
        }
        
        intakeLabel.snp.makeConstraints {
            $0.top.equalTo(intakeBackgroundView.snp.top).offset(34)
            $0.left.equalTo(intakeBackgroundView.snp.left).offset(21)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(intakeLabel.snp.bottom).offset(33)
            $0.horizontalEdges.equalTo(intakeBackgroundView).inset(14)
            $0.height.equalTo(21)
        }
        
        safeLabel.snp.makeConstraints {
            $0.centerY.equalTo(intakeLabel)
            $0.right.equalTo(deadLabel.snp.left).offset(-16)
        }
        
        safePointImage.snp.makeConstraints {
            $0.centerX.equalTo(safeLabel)
            $0.centerY.equalTo(progressView)
        }
        
        deadLabel.snp.makeConstraints {
            $0.centerY.equalTo(intakeLabel)
            $0.right.equalTo(intakeBackgroundView.snp.right).offset(-11)
        }
        
        deadPointImage.snp.makeConstraints {
            $0.centerX.equalTo(deadLabel)
            $0.centerY.equalTo(progressView)
        }
        
        alcoholTableView.snp.makeConstraints {
            $0.top.equalTo(backgroundLine.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(intakeBackgroundView).inset(1)
            $0.bottom.equalTo(intakeBackgroundView.snp.bottom).offset(-30)
            $0.height.equalTo(0)
        }
        
        // MARK: - 겪은 숙취
        hangoverBackgroundView.snp.makeConstraints {
            $0.top.equalTo(intakeBackgroundView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        hangoverTitleLabel.snp.makeConstraints {
            $0.top.equalTo(hangoverBackgroundView.snp.top).offset(27)
            $0.left.equalTo(hangoverBackgroundView.snp.left).offset(35)
        }
        
        hangoverTableView.snp.makeConstraints {
            $0.top.equalTo(hangoverTitleLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalTo(hangoverBackgroundView).inset(1)
            $0.bottom.equalTo(hangoverBackgroundView.snp.bottom).offset(-20)
            $0.height.equalTo(0)
        }
        
        // MARK: - 획득한 먹이
        feedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(hangoverBackgroundView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        
        feedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(feedBackgroundView.snp.top).offset(27)
            $0.left.equalTo(feedBackgroundView.snp.left).offset(35)
        }
        
        feedLabel.snp.makeConstraints {
            $0.top.equalTo(feedTitleLabel.snp.bottom).offset(5)
            $0.left.equalTo(feedTitleLabel.snp.left)
            $0.bottom.equalTo(feedBackgroundView.snp.bottom).offset(-25)
        }
        
        feedImage.snp.makeConstraints {
            $0.centerY.equalTo(feedLabel)
            $0.right.equalTo(feedBackgroundView)
            $0.width.equalTo(90)
            $0.height.equalTo(64)
        }
    }
}

import SwiftUI
#Preview {
    CalendarDetailView()
}
