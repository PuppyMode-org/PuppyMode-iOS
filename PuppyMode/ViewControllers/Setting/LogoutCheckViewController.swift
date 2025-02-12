//
//  LogoutCheckViewController.swift
//  PuppyMode
//
//  Created by 이승준 on 2/6/25.
//

import UIKit

class LogoutCheckViewController: UIViewController {
    
    let logoutView = LogoutCheckView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = logoutView
        addButtonActions()
    }
    
    private func addButtonActions() {
        logoutView.confirmButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutView.cancelButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
    }
    
    @objc
    private func logout() {
        _ = UserInfoService.deleteAllKeys()
        RootViewControllerService.toLoginViewController()
    }
    
    @objc
    private func popView() {
        dismiss(animated: true, completion: nil)
    }
    
}
