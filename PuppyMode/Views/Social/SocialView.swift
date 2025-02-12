//
//  SocialView.swift
//  PuppyMode
//
//  Created by 김미주 on 07/01/2025.
//

import UIKit

class SocialView: UIView {
    let attributes: [NSAttributedString.Key: Any] = [ .foregroundColor :  UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)] // Set text color to blue
    
    private lazy var rankingIcon = UIImageView().then {
        $0.image = .rankingIcon
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then { label in
        label.text = "랭킹"
        label.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
    }
    
    public lazy var segmentView = UISegmentedControl(items: ["전체 랭킹", "친구 랭킹"]).then { seg in
        let customFont = UIFont(name: "NotoSansKR-Medium", size: 16)!
        seg.selectedSegmentIndex = 0
        
        seg.setTitleTextAttributes([
            .foregroundColor: UIColor.darkGray,
            .font: customFont
        ], for: .normal)
        
        seg.setTitleTextAttributes([
            .foregroundColor: UIColor.darkGray,
            .font: customFont
        ], for: .selected)
        
    }
    
    public lazy var myRankView = RankingTableViewCell()
    
    public lazy var rankingTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
        $0.rowHeight = 65
        $0.allowsSelection = false
        $0.register( RankingTableViewCell.self, forCellReuseIdentifier: RankingTableViewCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(rankingIcon)
        self.addSubview(titleLabel)
        self.addSubview(segmentView)
        self.addSubview(myRankView)
        self.addSubview(rankingTableView)
        
        rankingIcon.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-8)
            make.width.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        segmentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
        }
        
        myRankView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom).offset(10)
            make.height.equalTo(65)
        }
        
        rankingTableView.snp.makeConstraints { make in
            make.top.equalTo(myRankView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public func addMyRankView() {
        
        myRankView.isHidden = false
        
        rankingTableView.snp.remakeConstraints { make in
            make.top.equalTo(myRankView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public func removeMyRankView() {
        myRankView.isHidden = true
        
        rankingTableView.snp.remakeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
