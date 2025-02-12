//
//  HangoverView.swift
//  PuppyMode
//
//  Created by 김미주 on 15/01/2025.
//

import UIKit
import Then
import SnapKit

class HangoverView: UIView {
    // MARK: - view
    // 뒤로가기
    public let backButton = UIButton().then {
        $0.setImage(.iconBack, for: .normal)
    }
    
    // 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "1. 숙취 선택"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    // 질문 + 설명
    private let questionLabel = UILabel().then {
        $0.text = "Q. 어떤 숙취를 겪으셨나요?"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 24)
    }
    
    private let descLabel = UILabel().then {
        $0.text = "숙취가 없으시면 건너뛰기를 눌러주세요"
        $0.textColor = UIColor(red: 0.467, green: 0.467, blue: 0.467, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
    }
    
    // 숙취 컬렉션뷰
    public let hangoverCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .init(width: 90, height: 110)
        $0.minimumInteritemSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(HangoverCollectionViewCell.self, forCellWithReuseIdentifier: HangoverCollectionViewCell.identifier)
    }
    
    // 버튼 스택뷰
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    
    public let skipButton = UIButton().then {
        $0.backgroundColor = .white
        
        $0.setTitle("건너뛰기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)

        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 10
    }
    
    public let nextButton = UIButton().then {
        $0.backgroundColor = .white

        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)

        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 10
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
    private func setStackView() {
        [ skipButton, nextButton ].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func setView() {
        setStackView()
        
        [
            backButton,
            titleLabel,
            questionLabel,
            descLabel,
            hangoverCollectionView,
            buttonStackView
        ].forEach {
            addSubview($0)
        }
        
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
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(72)
            $0.left.equalToSuperview().offset(33)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(9)
            $0.left.equalTo(questionLabel.snp.left).offset(32)
        }
        
        hangoverCollectionView.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.height.equalTo(230)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-42)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        skipButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
}
