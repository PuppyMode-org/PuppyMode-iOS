//
//  CalendarHangoverTableViewCell.swift
//  PuppyMode
//
//  Created by 김미주 on 11/02/2025.
//

import UIKit

class CalendarHangoverTableViewCell: UITableViewCell {
    static let identifier = "CalendarAlcoholTableViewCell"
    
    // MARK: - layout
    private let backView = UIView()
    
    public let hangoverLabel = UILabel().then {
        $0.text = "숙취"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 15.2)
    }
    
    public let hangoverImage = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - function
    private func setView() {
        [
            backView, hangoverLabel, hangoverImage
        ].forEach {
            addSubview($0)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        hangoverLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(34)
        }
        
        hangoverImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-34)
            $0.width.equalTo(46.5)
            $0.height.equalTo(48.5)
        }
    }
}
