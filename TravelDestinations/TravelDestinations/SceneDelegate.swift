import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Make sure we have a window scene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create the window
        window = UIWindow(windowScene: windowScene)
        
        // Create main view controller
        let mainViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // Set as root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
