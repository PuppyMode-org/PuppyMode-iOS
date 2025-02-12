//
//  UIViewController+Extension.swift
//  PuppyMode
//
//  Created by 김민지 on 1/13/25.
//


import UIKit

extension UIViewController {
    
    func setupNavigationBar(title: String, rightText: String) {
        // Create a custom navigation bar container
        let navigationBar = UIView()
        navigationBar.backgroundColor = UIColor.white
        view.addSubview(navigationBar)
        
        // Add constraints for the navigation bar using SnapKit
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top) // safeAreaLayoutGuide 기준으로 설정
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56) // Adjust height as needed
        }
        
        // Create a title label for the navigation bar
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: "#3C3C3C")
        titleLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        titleLabel.textAlignment = .center
        navigationBar.addSubview(titleLabel)
        
        // Add constraints for the title label using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(navigationBar) // 네비게이션 바의 중앙에 위치
        }
        
        // Create a close button (back button) for the left side of the navigation bar
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "left_arrow"), for: .normal) // Replace with your back arrow image name
        closeButton.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        navigationBar.addSubview(closeButton)
        
        // Add constraints for the close button using SnapKit
        closeButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar.snp.leading).offset(16) // safeAreaLayoutGuide와 동일한 위치로 설정
            make.centerY.equalTo(navigationBar) // 네비게이션 바의 수직 중앙에 위치
            make.width.equalTo(13)
            make.height.equalTo(20)
        }
        
        let rightLabel = UILabel()
        rightLabel.text = rightText
        rightLabel.textColor = UIColor(hex: "#3C3C3C")
        rightLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        titleLabel.textAlignment = .right
        navigationBar.addSubview(rightLabel)
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar.snp.trailing).inset(16)
            make.centerY.equalTo(navigationBar)
        }

        

    }
    
    @objc func customBackButtonTapped() {
        if let navigationController = self.navigationController {
            // 네비게이션 스택에서 이전 화면으로 이동
            navigationController.popViewController(animated: true)
        } else {
            // 네비게이션 컨트롤러가 없으면 모달 닫기
            dismiss(animated: true, completion: nil)
        }
    }
}


