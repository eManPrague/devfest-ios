import UIKit

protocol Scene {
    var viewController: UIViewController { get }
}

class NavigationScene: NSObject, UINavigationControllerDelegate, Scene {
    
    private var scenes = [Scene]()
    private let navigationController: UINavigationController
    
    var viewController: UIViewController {
        return navigationController
    }
    
    init(rootScene: Scene, navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController ?? UINavigationController(rootViewController: rootScene.viewController)
        super.init()
        
        self.navigationController.delegate = self
        scenes.append(rootScene)
    }
    
    func push(scene: Scene) {
        navigationController.pushViewController(scene.viewController, animated: true)
        scenes.append(scene)
    }
    
    func pop(scene: Scene) {
        guard navigationController.topViewController == scene.viewController else { return }
        navigationController.popViewController(animated: true)
        scenes.removeLast()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        scenes = navigationController.viewControllers.map { viewController in
            scenes.filter { $0.viewController == viewController }.first!
        }
    }
    
    func setScenes(scenes: [Scene], animated: Bool) {
        navigationController.setViewControllers(scenes.map { $0.viewController }, animated: animated)
        navigationController.navigationItem.hidesBackButton = scenes.count == 1
        self.scenes = scenes
    }
}

class PresentationScene: Scene {
    
    private var scene: Scene?
    private let presentingViewController: UIViewController
    
    var viewController: UIViewController {
        return presentingViewController
    }
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func present(scene: Scene) {
        presentingViewController.present(scene.viewController, animated: true, completion: nil)
        self.scene = scene
    }
    
    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
        scene = nil
    }
}
