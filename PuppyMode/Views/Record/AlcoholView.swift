//
//  AlcoholView.swift
//  PuppyMode
//
//  Created by 김미주 on 22/01/2025.
//

import UIKit
import Then
import SnapKit

class AlcoholView: UIView {
    // MARK: - view
    // 뒤로가기
    public let backButton = UIButton().then {
        $0.setImage(.iconBack, for: .normal)
    }
    
    // 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "주종 선택"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    // 주종 옵션 컬렉션뷰
    public let alcoholCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.estimatedItemSize = .init(width: 58, height: 58)
        $0.minimumLineSpacing = 25
    }).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(AlcoholKindCollectionViewCell.self, forCellWithReuseIdentifier: AlcoholKindCollectionViewCell.identifier)
        
        // padding 값 설정
        $0.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    // 주종 세부 테이블뷰
    public let alcoholTableView = UITableView().then {
        $0.register(AlcoholDetailTableViewCell.self, forCellReuseIdentifier: AlcoholDetailTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    // 직접 추가 버튼
    private let plusButton = UIButton().then {
        $0.setImage(.iconPlus, for: .normal)
        $0.imageView?.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        $0.setTitle("직접 추가", for: .normal)
        $0.setTitleColor(UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 15)
    }

    
    // 다음 버튼
    public let nextButton = UIButton().then {
        $0.backgroundColor = .main

        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1), for: .normal)
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
    private func setView() {
        [
            backButton,
            titleLabel,
            alcoholCollectionView,
            alcoholTableView,
            plusButton,
            nextButton
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
        
        alcoholCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        alcoholTableView.snp.makeConstraints {
            $0.top.equalTo(alcoholCollectionView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(plusButton.snp.top).offset(-20)
        }
        
        plusButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-47)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
}
