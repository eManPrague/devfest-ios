import Foundation
import UIKit
import RxSwift

class AppScene: Scene {
    
    
    // MARK: Public
    
    var viewController: UIViewController { return currentScene.viewController }
    
    // MARK: Private

    private let rigaScene = RigaScene()
    private let presenter = AppPresenter()
    
    private var currentScene: Scene
    private let bag = DisposeBag()
    private var window: UIWindow!
    
    // MARK: Lifecycle

    init(window: UIWindow) {
        self.window = window
        currentScene = rigaScene
        rigaScene.didSelectGameObservable.map({ _ in !LoginManager.isUserLogged }).subscribe(onNext: start).disposed(by: bag)
    }
    
    // MARK: Public
    
    // Starts the whole thing
    func start() {
        window.rootViewController = rigaScene.viewController
        change(scene: rigaScene, animated: false)
    }

    // MARK: Private
    
    private func createGameScene() -> RootScene {
        let s = RootScene()
        let rs = rigaScene
        s.exitGameObservable.map({ _ in (rs, true) }).subscribe(onNext: change).disposed(by: bag)
        return s
    }
    
    private func start(withLogin: Bool) {
        // Dispose if the disposable exists for the same reason as mentioned above
        LoginManager.userDisposable?.dispose()
        if withLogin {
            if let vc = window.rootViewController {
                LoginManager.shared.presentLogin(fromVC: vc)
                LoginManager.userDisposable = GameDataManager.shared.currentUserObservable.take(1).subscribe(onNext: { [weak self] _ in
                    if let ss = self {
                        vc.dismiss(animated: true)
                        ss.change(scene: ss.createGameScene(), animated: true)
                    }
                    // Dispose
                    LoginManager.userDisposable?.dispose()
                })
            }
        } else {
            change(scene: createGameScene(), animated: true)
        }
    }

    private func change(scene: Scene, animated: Bool) {
        if type(of: currentScene) != type(of: scene) {
            window.rootViewController = scene.viewController
            currentScene = scene
            if animated {
                if let snap = window.snapshotView(afterScreenUpdates: false) {
                    window.addSubview(snap)
                    window.layoutIfNeeded()
                    UIView.animate(withDuration: 0.2, animations: {
                        snap.alpha = 0
                    }, completion: { (finished) in
                        snap.removeFromSuperview()
                    })
                }
            }
        }
    }
    
}
