//
//  PuppyCardButton.swift
//  PuppyMode
//
//  Created by 이승준 on 2/3/25.
//

import UIKit

class PuppyCardButtonView: UIButton {
    public lazy var puppyImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .defaultPuppy
    }
    
    private var id: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFrame()
        addComponents()
    }
    
    private func setFrame() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1).cgColor
    }
    
    private func addComponents() {
        self.addSubview(puppyImage)
        self.backgroundColor = .white
        puppyImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
    }
    
    public func setId(id: Int) {
        self.id = id
    }
    
    public func getID() -> Int? {
        return self.id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
