//
//  LoginView.swift
//  PuppyMode
//
//  Created by 이승준 on 1/10/25.
//

import UIKit

class LoginView: UIView {
    
    private lazy var slogunLabel = UILabel().then { label in
        label.text = "어차피 못지킬 약속,\n강아지 모드가 도와드립니다."
        label.numberOfLines = 0
        label.font = UIFont(name: "NotoSansKR-Bold", size: 28)
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        label.backgroundColor = .clear
    }
    
    private lazy var underline = UIView().then { view in
        view.backgroundColor = .main
    }
    
    private lazy var subLabel = UILabel().then { label in
        label.text = "올바른 음주 습관을 가질 수 있도록 도와드릴게요"
        label.numberOfLines = 0
        label.font = UIFont(name: "NotoSansKR-Medium", size: 17)
        label.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.97
        // Line height: 24 pt
        // (identical to box height)
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "올바른 음주 습관을 가질 수 있도록 도와드릴게요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    private lazy var characterImage1 = UIImageView().then { image in
        image.image = .welshCorgiHiding
        image.backgroundColor = .clear
    }
    
    private lazy var characterImage2 = UIImageView().then { image in
        image.image = .welshCorgiShowed
        image.backgroundColor = .clear
        image.alpha = 0
    }
    
    public lazy var appleLoginButton = SocialLoginButton()
    
    public lazy var kakaoLoginButton = SocialLoginButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
        choosePuppy()
        startImageTransition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(characterImage1)
        self.addSubview(characterImage2)
        self.addSubview(underline)
        self.addSubview(slogunLabel)
        self.addSubview(subLabel)
        self.addSubview(appleLoginButton)
        self.addSubview(kakaoLoginButton)
        
        underline.snp.makeConstraints { make in
            make.leading.bottom.equalTo(slogunLabel)
            make.height.equalTo(17)
            make.width.equalTo(137)
        }
        
        slogunLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slogunLabel.snp.bottom).offset(17)
        }
        
        self.bringSubviewToFront(slogunLabel)
        self.bringSubviewToFront(subLabel)
        
        kakaoLoginButton.configure(name: "카카오 로그인", logo: UIImage(named: "KakaoLogin")!, backgroundColor: .kakaoLogin)
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-20)
        }
        
        appleLoginButton.configure(name: "Apple로 로그인", logo: UIImage(named: "AppleLogin")!, backgroundColor: .white)
        appleLoginButton.addFrame()
        
        appleLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(60)
        }
        
    }
    
    private func startImageTransition() {
        // Phase 1: 이미지 서로 전환 (0.5초)
        UIView.animate(withDuration: 1.5) {
            self.characterImage1.alpha = 0
            self.characterImage2.alpha = 1
        } completion: { _ in
            // Phase 2: 1초 유지
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Phase 3: 원래 상태 복구 (0.5초)
                UIView.animate(withDuration: 1.5) {
                    self.characterImage1.alpha = 1
                    self.characterImage2.alpha = 0
                } completion: { _ in
                    // Phase 4: 1초 유지 후 사이클 재시작
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.startImageTransition()
                    }
                }
            }
        }
    }
    
    private func choosePuppy() {
        switch Int.random(in: 1...2) {
        case 1:
            characterImage1.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(450)
                make.width.equalTo(500)
            }
            characterImage2.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(450)
                make.width.equalTo(500)
            }
        case 2:
            characterImage1.image = .normalPuppyHiding
            characterImage2.image = .normalPuppyShowed
            characterImage1.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(450)
                make.width.equalTo(500)
            }
            
            characterImage2.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(450)
                make.width.equalTo(550)
            }
        default:
            return
        }
    }
    
}

import SwiftUI
#Preview {
    LoginViewController()
}
