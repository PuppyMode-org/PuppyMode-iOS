//
//  HomeView.swift
//  PuppyMode
//
//  Created by 김미주 on 07/01/2025.
//

import UIKit
import SnapKit
import Then
import SDWebImage
import SDWebImageSVGKitPlugin

class HomeView: UIView {
    
    let superViewSpacing: CGFloat = 16
    
    lazy public var editDogNameButton = UIButton().then { button in
        button.setImage(UIImage(named: "EditButtonIcon"), for: .normal)
    }
    
    //MARK: Top Buttons
    lazy private var topButtonStack = UIView()
    
    let topRectangleHeight = 53
    let topRectangleWidth = 53
    let topButtonsCornerRadius: CGFloat = 10
    let topButtonSpacing = 11
    let topButtonSuperViewSpacing = 22
    
    lazy public var decorationButton = UIButton().then { button in
        button.setImage(UIImage(named: "DecorationButtonImage"), for: .normal)
        button.layer.cornerRadius = topButtonsCornerRadius
    }
    
    lazy public var rompingButton = UIButton().then { button in
        button.setImage(UIImage(named: "RompingButtonImage"), for: .normal)
        button.layer.cornerRadius = topButtonsCornerRadius
    }
    
    lazy public var countdownLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = UIFont(name: "NotoSansKR-Bold", size: 14)!
        label.textColor = UIColor(hex: "#3C3C3C")
    }
    
    lazy public var collectionButton = UIButton().then { button in
        button.setImage(UIImage(named: "CollectionButtonImage"), for: .normal)
        button.layer.cornerRadius = topButtonsCornerRadius
    }
    
    lazy private var decorationLabel = UILabel().then { label in
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.font = UIFont(name: "NotoSansKR-Bold", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.28
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "꾸미기", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    lazy private var rompingLabel = UILabel().then { label in
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.font = UIFont(name: "NotoSansKR-Bold", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.28
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "놀아주기", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    lazy private var collectionLabel = UILabel().then { label in
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.font = UIFont(name: "NotoSansKR-Bold", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.28
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "컬렉션", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    //MARK: Puppy Image & Name
    
    lazy public var puppyImageButton = UIButton().then { button in
        button.setImage(UIImage(named: "HomeCharacterDefaultImage"), for: .normal)
    }
    
    lazy private var puppyNameLabel = UILabel().then { label in
        label.font = UIFont(name: "OTSBAggroM", size: 25)
        label.text = "눈송이 비숑"
        label.textColor = .black
    }
    
    //MARK: Bottom Dog Info
    private lazy var puppyDashboardFrame = UIView().then { view in
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).cgColor
    }
    
    lazy public var dogInfoLabel = UILabel().then { label in
        label.font = UIFont(name: "OTSBAggroM", size: 14)
        label.text = "dogInfoLabel"
        label.textColor = UIColor(red: 0.624, green: 0.584, blue: 0.584, alpha: 1)
    }
    
    lazy public var progressLabel = UILabel().then { label in
        label.font = UIFont(name: "NotoSansKR-Bold", size: 14)
        label.text = "55%"
        label.textColor = UIColor(red: 0.624, green: 0.584, blue: 0.584, alpha: 1)
    }
    
    lazy public var progressBar = UIProgressView().then{ pro in
        pro.setProgress(0.55, animated: false)
        pro.tintColor = .main
        pro.largeContentImage = UIImage(named: "ProgressBarBackground")
        pro.clipsToBounds = true
        pro.layer.cornerRadius = 10.5
    }
    
    //MARK: Drinking Capacity Button
    private lazy var buttonStack = UIView()
    
    lazy public var drinkingCapacityButton = HomeCustomButtonView()
    lazy public var addDrinkingHistoryButton = HomeCustomButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
        self.addTopButtonComponents()
        self.addPuppyImageAndName()
        self.addButtomComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeView {
    
    public func configurePuppyInfo(to puppyInfo: PuppyInfoResult) {
        puppyNameLabel.text = puppyInfo.puppyName
        dogInfoLabel.text = "Level" + String(puppyInfo.level) + " " + puppyInfo.levelName
        let total = Double(puppyInfo.levelMaxExp - puppyInfo.levelMinExp)
        let progress = Double(puppyInfo.puppyExp - puppyInfo.levelMinExp)
        
        let percentageDouble = progress / total
        
        progressLabel.text = String(Int(percentageDouble * 100)) + "%"
        progressBar.setProgress(Float(percentageDouble), animated: false)
        
        puppyImageButton.sd_setImage(
            with: URL(string: puppyInfo.imageUrl!)!,
            for: .normal,
            placeholderImage: nil,
            options: [],
            context: [
                .imageThumbnailPixelSize: CGSize(width: 100, height: 100),
                .imagePreserveAspectRatio: true
            ]
        )
    }
    
}

//MARK: Add Compoments
extension HomeView {
    
    private func addTopButtonComponents() {
        self.addSubview(topButtonStack)
        
        topButtonStack.addSubview(rompingButton)
        topButtonStack.addSubview(decorationButton)
        topButtonStack.addSubview(collectionButton)
        
        topButtonStack.addSubview(decorationLabel)
        topButtonStack.addSubview(rompingLabel)
        topButtonStack.addSubview(collectionLabel)
        
        topButtonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(topButtonSuperViewSpacing)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(52)
            make.height.equalTo(topRectangleHeight)
        }
        
        decorationButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(rompingButton.snp.leading).offset(-topButtonSpacing)
            make.height.equalTo(topRectangleHeight)
            make.width.equalTo(topRectangleWidth)
        }
        
        rompingButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(collectionButton.snp.leading).offset(-topButtonSpacing)
            make.height.equalTo(topRectangleHeight)
            make.width.equalTo(topRectangleWidth)
        }
        
        rompingButton.addSubview(countdownLabel)
        
        countdownLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        collectionButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(topRectangleHeight)
            make.width.equalTo(topRectangleWidth)
        }
        
        rompingLabel.snp.makeConstraints { make in
            make.top.equalTo(rompingButton.snp.bottom).offset(-2)
            make.centerX.equalTo(rompingButton.snp.centerX)
        }
        
        decorationLabel.snp.makeConstraints { make in
            make.top.equalTo(decorationButton.snp.bottom).offset(-2)
            make.centerX.equalTo(decorationButton.snp.centerX)
        }
        
        collectionLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionButton.snp.bottom).offset(-2)
            make.centerX.equalTo(collectionButton.snp.centerX)
        }
        
    }

    private func addPuppyImageAndName() {
        
        self.addSubview(puppyImageButton)
        
        puppyImageButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(superViewSpacing)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.top.equalTo(topButtonStack.snp.bottom).offset(41)
        }
        
        self.addSubview(puppyNameLabel)
        
        puppyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(puppyImageButton.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addButtomComponents() {
        
        self.addSubview(puppyDashboardFrame)
        
        puppyDashboardFrame.addSubview(dogInfoLabel)
        puppyDashboardFrame.addSubview(progressLabel)
        puppyDashboardFrame.addSubview(progressBar)
        
        puppyDashboardFrame.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(puppyNameLabel.snp.bottom).offset(19)
            make.height.equalToSuperview().multipliedBy(0.30)
        }
        
        dogInfoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(27)
            make.top.equalToSuperview().offset(31)
            make.height.equalTo(24)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-37)
            make.top.equalToSuperview().offset(31)
            make.height.equalTo(24)
        }
        
        progressBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(progressLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(27)
            make.height.equalTo(21)
        }
        
        puppyDashboardFrame.addSubview(buttonStack)
        
        buttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(progressBar.snp.bottom).offset(25)
            make.height.equalToSuperview().multipliedBy(0.45)
        }
        
        buttonStack.addSubview(drinkingCapacityButton)
        
        drinkingCapacityButton.setTitleLabel(to: "주량 확인")
        drinkingCapacityButton.setSubTitleLabel(to: "술 마실 거에요")
        
        drinkingCapacityButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(buttonStack.snp.width).multipliedBy(0.48)
        }
        
        buttonStack.addSubview(addDrinkingHistoryButton)
        
        addDrinkingHistoryButton.setTitleLabel(to: "음주 기록")
        addDrinkingHistoryButton.setSubTitleLabel(to: "술 마셨어요")
        
        addDrinkingHistoryButton.snp.makeConstraints { make in
            make.height.equalTo(drinkingCapacityButton.snp.height)
            make.width.equalTo(drinkingCapacityButton.snp.width)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
    }
}

import SwiftUI
#Preview {
    HomeViewController()
}
