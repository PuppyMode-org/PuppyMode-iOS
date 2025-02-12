//
//  SDKImageView.swift
//  PuppyMode
//
//  Created by 이승준 on 2/9/25.
//

import UIKit
import WebKit
import SnapKit
import Then
import SDWebImageSVGNativeCoder

class SVGImageView: UIView {
    
    private var webImage = WKWebView().then {
        $0.load(URLRequest(url: URL(string: "https://svgsilh.com/svg/2056977.svg")!))
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .babyPomeranian
        $0.backgroundColor = .caution
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        addComponents()
    }
    
    private func addComponents() {
        let svgURL = URL(string: "https://svgsilh.com/svg/2056977.svg")!
        
        self.addSubview(webImage)
        self.addSubview(imageView)
        
        webImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        imageView.sd_setImage(
            with: svgURL,
            placeholderImage: .appleLogin,
            context: [
                .imageThumbnailPixelSize: CGSize(width: 300, height: 200),
                .imagePreserveAspectRatio: true,
                .imageCoder: SDImageSVGNativeCoder.shared
            ]
        )
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(webImage.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
