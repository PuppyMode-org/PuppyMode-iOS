import UIKit
import AuthenticationServices
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = BaseViewController()
        window?.makeKeyAndVisible()
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        guard let userID = KeychainService.get(key: "AppleUserID") else { // New User
            self.window?.rootViewController = LoginViewController()
            return
        }
        
        appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    self.window?.rootViewController = BaseViewController()
                }
            case .revoked:
                print("revoked or notFound")
                self.window?.rootViewController = LoginViewController()
            case .notFound:
                print("notFound")
                self.window?.rootViewController = LoginViewController()
            case .transferred:
                print("transferred")
            default:
                self.window?.rootViewController = LoginViewController()
            }
        }
    }
    
    // 로그인이 화면 이동 후, 다시 앱으로 돌아오는 UI가 관련된 설정
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func changeRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        
        window.rootViewController = viewController
        
        if animated {
            UIView.transition(with: window,
                             duration: 0.5,
                             options: .transitionFlipFromRight,
                             animations: nil,
                             completion: nil)
        }
    }

}

