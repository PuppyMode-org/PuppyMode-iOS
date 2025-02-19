//
//  RecordCompleteView.swift
//  PuppyMode
//
//  Created by 박준석 on 1/27/25.
//

import UIKit
import SnapKit
import Then

class RecordCompleteView: UIView {
    
    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 완료"
        label.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "주량을 잘 조절해서 마셨네요!"
        label.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    let steakImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let rewardLabel: UILabel = {
        let label = UILabel()
        label.text = "보상을 획득했어요!"
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("먹이주러 가기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        button.titleLabel?.font =  UIFont(name: "NotoSansKR-Regular", size: 15)
        return button
    }()
    
    let progressComponentView = ProgressComponentView()
    
    let progressBackView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views and Layouts
    private func setupViews() {
        
        // Add subviews to the view hierarchy
        [titleLabel, messageLabel, steakImageView, rewardLabel, actionButton, progressBackView, progressComponentView].forEach { addSubview($0) }
        
        // Set constraints using SnapKit
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
        }
        
        steakImageView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(44)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
        }
        
        rewardLabel.snp.makeConstraints { make in
            make.top.equalTo(steakImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(168) // 버튼 너비
            make.height.equalTo(46) // 버튼 높이
        }
        
        progressBackView.snp.makeConstraints {
            $0.top.equalTo(progressComponentView.snp.top).offset(-15)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(240)
        }
        
        progressComponentView.snp.makeConstraints{ make in
            make.top.equalTo(actionButton.snp.bottom).offset(95)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
}

class ProgressComponentView: UIView {
    
    // MARK: - UI Components
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Level 1 아기사자 포메라니안"
        label.textColor = UIColor(red: 0.624, green: 0.584, blue: 0.584, alpha: 1)
        label.font = UIFont(name: "OTSBAggroM", size: 14)
        return label
    }()
    
    private let progressView = UIProgressView().then {
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
    
    private let progressPercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "55%"
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.font = UIFont(name: "NotoSansKR-Medium", size: 15)
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white // Set background color to white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views and Layouts
    private func setupViews() {
        
        // Add subviews to the view hierarchy
        [progressLabel, progressView, progressPercentageLabel].forEach { addSubview($0) }
        
        // Set constraints using SnapKit
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(progressView.snp.leading).offset(5)
        }
        
        progressPercentageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(progressView.snp.trailing)
            make.centerY.equalTo(progressLabel)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(7)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(21)
        }
    }
    
    // MARK: - Public Methods to Update Progress
    func updateProgress(to value: Float, percentageText: String) {
        progressView.progress = value
        progressPercentageLabel.text = percentageText
    }
    
    func setLevelText(_ text: String) {
        progressLabel.text = text
    }
}

import SwiftUI
#Preview {
    RecordCompleteView()
}
