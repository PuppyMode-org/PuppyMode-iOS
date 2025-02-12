//
//  DrankAlcoholTableViewCell.swift
//  PuppyMode
//
//  Created by 박준석 on 1/29/25.
//

import UIKit

class DrankAlcoholTableViewCell: UITableViewCell {
    // MARK: - Views
    let backView = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1).cgColor
    }
    
    let alcoholImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1).cgColor
    }
    
    let alcoholNameLabel = UILabel().then {
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
        $0.textColor = UIColor(red: 138 / 255, green: 138 / 255, blue: 142 / 255, alpha: 1.0)
    }
    
    let sliderValueLabel = UILabel().then {
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15)
        $0.textColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    }
    
    let deleteButton = UIButton(type: .system).then {
        $0.setImage(.iconMinus, for: .normal)
        $0.tintColor = .black
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupViews() {
        contentView.addSubview(backView)
        contentView.addSubview(alcoholImageView)
        contentView.addSubview(alcoholNameLabel)
        contentView.addSubview(sliderValueLabel)
        contentView.addSubview(deleteButton)
        
        backView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        alcoholImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(72)
        }
        
        alcoholNameLabel.snp.makeConstraints {
            $0.left.equalTo(alcoholImageView.snp.right).offset(24)
            $0.centerY.equalToSuperview()
            $0.width.lessThanOrEqualTo(100)
        }
        
        sliderValueLabel.snp.makeConstraints {
            $0.right.equalTo(deleteButton.snp.left).offset(-50)
            $0.centerY.equalToSuperview()
            $0.width.lessThanOrEqualTo(60)
        }
        
        deleteButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
        }
    }
}
