import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Create the input view controller
        let inputViewController = InputViewController()
        
        // Embed in navigation controller
        let navigationController = UINavigationController(rootViewController: inputViewController)
        
        // Set as root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // Other scene delegate methods remain unchanged
}
