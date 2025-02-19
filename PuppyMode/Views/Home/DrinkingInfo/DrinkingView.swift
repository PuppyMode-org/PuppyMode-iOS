//
//  DrinkingView.swift
//  PuppyMode
//
//  Created by 박준석 on 1/24/25.
//

import UIKit
import SnapKit
import Then

class DrinkingView: UIView {

    // Dog Image
    private let dogImageView = UIImageView().then {
        $0.image = UIImage(named: "drinkingPuppy") // Replace with your actual image name
        $0.contentMode = .scaleAspectFit
    }

    // Title Label
    let titleLabel = UILabel().then {
        $0.text = "술 마시는 중"
        $0.textAlignment = .center
        
        $0.textColor = UIColor(hex: "#3C3C3C")
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }

    // Progress Label
    let progressNameLabel = UILabel().then {
        $0.text = "브로콜리가 지켜보고 있어요!"
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(hex: "#3C3C3C")
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    // Progress Label
    let progressTimeLabel = UILabel().then {
        $0.text = "00시간 째 술마시는 중"
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(hex: "#8A8A8E")
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 18)
    }

    let endButton = UIButton(type: .system).then {
        $0.setTitle("음주 종료하기", for: .normal)
        $0.setTitleColor(UIColor(hex: "#3C3C3C"), for: .normal)
        $0.backgroundColor = UIColor(hex: "#73C8B1")
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 18)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = UIColor(hex: "#FBFBFB")

        addSubview(dogImageView)
        addSubview(progressNameLabel)
        addSubview(progressTimeLabel)
        
        addSubview(endButton)
    }

    private func setupLayout() {

        dogImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(165)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250) // Adjust size as needed
        }

        progressNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dogImageView.snp.bottom).offset(47)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        progressTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(progressNameLabel.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        endButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
}
