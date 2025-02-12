//
//  BaseViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 07/01/2025.
//

import UIKit

// 탭바 커스텀 (높이 설정)
class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 94
        return size
    }
}

class BaseViewController: UITabBarController {
    
    private var homeVC: UINavigationController = {
        let homeViewController = HomeViewController()
        homeViewController.getPupptInfo()
        return UINavigationController(rootViewController: homeViewController)
    }()
    
    private let socialVC: UINavigationController = {
        let socialViewController = SocialViewController()
        return UINavigationController(rootViewController: socialViewController)
    }()
    
    private let calendarVC = UINavigationController(rootViewController: CalendarViewController())
    
    private lazy var settingVC: UINavigationController = {
        let settingViewController = SettingViewController()
        settingViewController.setToggle()
        return UINavigationController(rootViewController: settingViewController)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        SocialService.fetchGlobalRankData()
        
        // 탭바 아이템 설정
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        socialVC.tabBarItem = UITabBarItem(title: "소셜", image: UIImage(systemName: "person.2.fill"), tag: 1)
        calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 2)
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape.fill"), tag: 3)
        
        self.viewControllers = [homeVC, socialVC, calendarVC, settingVC]
    }
    
    override func loadView() {
        super.loadView()
        // CustomTabBar로 교체
        setValue(CustomTabBar(), forKey: "tabBar")
    }

    private func setupTabBar() {
        // 선택 아이템 색상
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = UIColor(red: 200/255, green: 194/255, blue: 194/255, alpha: 1)
        
        // 배경 색상
        tabBar.backgroundColor = .white
        
        // 모서리 둥글게
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
        
        // 그림자
        tabBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 9
        
        // 테두리
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = CGColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1)
        
        // 폰트
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "NotoSansKR-Medium", size: 12) ?? .systemFont(ofSize: 12)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "NotoSansKR-Regular", size: 12) ?? .systemFont(ofSize: 12)
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
