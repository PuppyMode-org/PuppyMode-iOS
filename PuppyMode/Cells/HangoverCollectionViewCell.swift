//
//  HangoverCollectionViewCell.swift
//  PuppyMode
//
//  Created by 김미주 on 17/01/2025.
//

import UIKit

class HangoverCollectionViewCell: UICollectionViewCell {
    static let identifier = "HangoverCollectionViewCell"
    
    // MARK: - Properties
    var isCellSelected: Bool = false {
        didSet {
            updateAlpha()
        }
    }
    
    // MARK: - Layout
    public let hangoverImage = UIImageView().then {
        $0.backgroundColor = .main
        $0.alpha = 0.5
    }
    
    public let hangoverLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        $0.alpha = 0.5
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isCellSelected = false
    }
    
    // MARK: - Functions
    private func setView() {
        [hangoverImage, hangoverLabel].forEach { addSubview($0) }
        
        hangoverImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        hangoverLabel.snp.makeConstraints {
            $0.top.equalTo(hangoverImage.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    public func updateAlpha() {
        self.hangoverImage.alpha = isCellSelected ? 1.0 : 0.5
        self.hangoverLabel.alpha = isCellSelected ? 1.0 : 0.5
    }
}
