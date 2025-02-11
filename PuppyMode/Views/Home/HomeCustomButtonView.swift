//
//  HomeCustomButtonView.swift
//  PuppyMode
//
//  Created by 이승준 on 1/9/25.
//

import UIKit

class HomeCustomButtonView: UIButton {
    
    lazy private var frameView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1).cgColor
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = false
    }
    
    lazy private var buttonTitleLabel = UILabel().then { label in
        label.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
    }
    
    lazy private var buttonSubtitleLabel = UILabel().then { label in
        label.font = UIFont(name: "NotoSansKR-Regular", size: 15)
        label.alpha = 0.78
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    private func addComponents() {
        self.addSubview(frameView)
        frameView.addSubview(buttonTitleLabel)
        frameView.addSubview(buttonSubtitleLabel)
        
        // framView의 제약조건 수정
        frameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        buttonSubtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonTitleLabel.snp.bottom).offset(10)
        }
    }
    
    public func setTitleLabel(to title: String) {
        buttonTitleLabel.text = title
    }
    
    public func setSubTitleLabel(to title: String) {
        buttonSubtitleLabel.text = title
    }
    
    func getTitleLabel() -> String? {
        return buttonTitleLabel.text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
