//
//  RevokeView.swift
//  PuppyMode
//
//  Created by 이승준 on 1/12/25.
//

import UIKit

class RevokeView: UIView {
    
    private lazy var titlaLabel = UILabel().then { label in
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.text = "탈퇴하기"
    }
    
    public lazy var popButton = UIButton().then { btn in
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.contentMode = .scaleAspectFit
    }
    
    private lazy var messageFrame = UIView().then { frame in
    }
    
    private lazy var mainMessageLabel = UILabel().then { label in
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.font = UIFont(name: "NotoSansKR-Bold", size: 28)
        label.text = "정말 떠나시나요?"
    }
    
    private lazy var characterImage = UIImageView().then { image in
        image.image = UIImage(named: "CryingDog")
        image.contentMode = .scaleAspectFit
    }
    
    private lazy var subMessageLabel = UILabel().then { label in
        label.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        label.font = UIFont(name: "NotoSansKR-Medium", size: 18)
        label.numberOfLines = 2
        label.text = "000 이는 이제 볼 수 없을지도 몰라요.."
    }
    
    public lazy var revokeButton = UIButton().then { btn in
        btn.setTitle("계정 삭제", for: .normal)
        btn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        btn.backgroundColor = .caution
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        self.addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(titlaLabel)
        self.addSubview(popButton)
        
        titlaLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        popButton.snp.makeConstraints { make in
            make.centerY.equalTo(titlaLabel.snp.centerY)
            make.leading.equalToSuperview().offset(37)
            make.width.equalTo(13)
            make.height.equalTo(20)
        }
        
        self.addSubview(messageFrame)
        messageFrame.addSubview(mainMessageLabel)
        messageFrame.addSubview(characterImage)
        messageFrame.addSubview(subMessageLabel)
        
        messageFrame.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(140)
            make.height.equalTo(103)
            make.leading.trailing.equalToSuperview().inset(36)
        }
        
        mainMessageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        
        characterImage.snp.makeConstraints { make in
            make.leading.equalTo(mainMessageLabel.snp.trailing).offset(8)
            make.top.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(58)
        }
        
        subMessageLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
        }
        
        self.addSubview(revokeButton)
        
        revokeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(48)
            make.height.equalTo(46)
        }
    }
    
    public func configure(_ name: String) {
        subMessageLabel.text = name + "이는 이제 볼 수 없을지도 몰라요.."
    }
}

#Preview{
    RevokeViewController()
}
