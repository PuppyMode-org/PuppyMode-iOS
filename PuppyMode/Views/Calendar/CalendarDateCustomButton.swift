//
//  CalendarDateCustomButton.swift
//  PuppyMode
//
//  Created by 김미주 on 10/02/2025.
//

import UIKit

class CalendarDateCustomButton: UIView {

    // MARK: - layout
    // 배경
    private let backView = UIButton().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        
        $0.layer.cornerRadius = 40
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor(red: 0.873, green: 0.873, blue: 0.873, alpha: 1).cgColor
    }
    
    // 동그라미
    private let circleView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        
        $0.layer.borderWidth = 5
        $0.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
    }
    
    private let gradientLayer = CAGradientLayer().then {
        $0.colors = [
            UIColor.white.cgColor,
            UIColor(red: 0.781, green: 0.781, blue: 0.781, alpha: 1).cgColor
        ]
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    // 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "미입력"
        $0.textColor = UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = circleView.bounds
        if gradientLayer.superlayer == nil {
            circleView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    // MARK: - function
    public func updateGradientColor(startColor: UIColor, endColor: UIColor) {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    private func setView() {
        [
            backView, circleView,
            titleLabel
        ].forEach {
            addSubview($0)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-3)
            $0.right.equalToSuperview().offset(-45)
        }
    }
}
