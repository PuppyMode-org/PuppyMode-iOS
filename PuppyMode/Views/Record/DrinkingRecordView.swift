//
//  DrinkingView.swift
//  PuppyMode
//
//  Created by 김미주 on 22/01/2025.
//

import UIKit

class DrinkingRecordView: UIView {
    // MARK: - view
    // 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "술을 얼마나 마셨나요?"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    // 추가 버튼
    public let plusButton = UIButton().then {
        $0.setImage(.iconPlus, for: .normal)
        $0.backgroundColor = .white
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.873, green: 0.873, blue: 0.873, alpha: 1).cgColor
        $0.layer.cornerRadius = 18
    }
    
    // 돌아가기 버튼
    public let backButton = UIButton().then {
        $0.backgroundColor = .white

        $0.setTitle("돌아가기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)

        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 10
    }
    
    // 입력 완료 버튼
    public let completeButton = UIButton().then {
        $0.backgroundColor = .main

        $0.setTitle("입력 완료", for: .normal)
        $0.setTitleColor(UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)

        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 10
    }
    
    // 스택뷰 생성 (뒤로가기 버튼 + 입력 완료 버튼)
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, completeButton])
        stackView.axis = .horizontal
        stackView.spacing = 16 // 버튼 간 간격 설정
        stackView.alignment = .fill
        stackView.distribution = .fillEqually // 버튼 크기를 동일하게 설정
        return stackView
    }()
    
    public let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
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
            titleLabel,
            plusButton,
            tableView,
            buttonStackView
        ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1)
        tableViewHeightConstraint?.isActive = true
        
        plusButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(36)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-47)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
    
    public func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint?.constant = max(contentHeight, 1) // Ensure height is at least 1
        
        // Force layout updates
        self.layoutIfNeeded()
    }
}
