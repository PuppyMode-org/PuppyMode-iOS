//
//  RankingTableViewCell.swift
//  PuppyMode
//
//  Created by 이승준 on 1/20/25.
//

import UIKit
import SnapKit
import Then

class RankingTableViewCell: UITableViewCell {
    
    static let identifier = "RankingTableViewCell"
    
    private lazy var spacing = UIView().then {
        $0.backgroundColor = UIColor(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
    }
    
    private lazy var rankLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        $0.textAlignment = .center
    }
    
    private lazy var profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .rankCellDefaultProfile
        $0.layer.cornerRadius = 21
        $0.clipsToBounds = true
    }
    
    private lazy var infoFrame = UIView()
    
    private lazy var userNameLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 16)
    }
    
    private lazy var characterInfoLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.396, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 12)
    }
    
    private lazy var trophyImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
    }
    
    public func configure(rankCell: RankUserInfo) {
        rankLabel.text = String(rankCell.rank)
        userNameLabel.text = String.sliceText(string: rankCell.username, max: 14)
        characterInfoLabel.text = String.sliceText(string: rankCell.puppyName ?? rankCell.levelName, max: 17) + ", Level\(rankCell.level) \(rankCell.levelName)"
        self.backgroundColor = .white
        
        trophyImageView.removeFromSuperview() // 기존 트로피 이미지 제거
        
        if rankCell.rank < 4 {
            addTrophyComponent(rank: Rank(rawValue: rankCell.rank) ?? .first)
        }
    }
    
    public func markMyRank() {
        self.backgroundColor = UIColor(red: 0.451, green: 0.784, blue: 0.694, alpha: 1)
    }
    
    private func addComponents() {
        self.addSubview(spacing)
        self.addSubview(rankLabel)
        self.addSubview(profileImage)
        self.addSubview(infoFrame)
        infoFrame.addSubview(userNameLabel)
        infoFrame.addSubview(characterInfoLabel)
        
        spacing.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.leading.trailing.top.equalToSuperview()
        }
        
        rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(66)
            make.centerY.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(42)
        }
        
        infoFrame.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.trailing.equalToSuperview().inset(20)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }
        
        characterInfoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(userNameLabel.snp.bottom).offset(1)
        }
    }
    
    public func addTrophyComponent(rank: Rank) {
        switch rank {
        case .first:
            trophyImageView.image = .firstTrophy
        case .second:
            trophyImageView.image = .secondTrophy
        case .third:
            trophyImageView.image = .thirdTrophy
        }
        
        infoFrame.addSubview(trophyImageView)
        
        trophyImageView.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.leading.equalTo(userNameLabel.snp.trailing).offset(6)
            make.height.width.equalTo(19)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

enum Rank: Int {
    case first = 1
    case second = 2
    case third = 3
}
