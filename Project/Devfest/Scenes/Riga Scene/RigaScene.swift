import Foundation
import UIKit
import RxSwift
import RxCocoa

class RigaScene: NSObject, Scene, UITabBarControllerDelegate {
    
    // MARK: Public
    var viewController: UIViewController { return vc }
    
    private let didSelectGameOutput = PublishSubject<Void>()
    var didSelectGameObservable: Observable<Void> { return didSelectGameOutput.asObservable() }

    // MARK: Private
    private let vc: RootTabBarController
    private let mapScene = MapNavigationScene()
    
    // MARK: Outputs
    
    // MARK: Lifecycle
    override init() {
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! RootTabBarController
        
        super.init()
        
        vc.delegate = self
        vc.viewControllers?.append(mapScene.viewController)
        vc.viewControllers?.append(DummyGameViewController())
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is DummyGameViewController {
            didSelectGameOutput.onNext()
            return false
        }
        
        return true
    }
}

class DummyGameViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        tabBarItem = UITabBarItem(title: locs("bottom_bar.title.game"), image: #imageLiteral(resourceName: "ic_game"), selectedImage: #imageLiteral(resourceName: "ic_game_active"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
