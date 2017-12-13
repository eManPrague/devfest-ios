import UIKit
import RxSwift

class RootScene: Scene {
    
    private let bag = DisposeBag()
    private let profileScene = ProfileNavigationScene()
    private let leaderboardScene = LeaderboardNavigationScene()
    
    private let presenter: RootPresenter
    private let vc: RootViewController
    var viewController: UIViewController
    
    // MARK: - Outputs
    
    private let exitGameOutput = PublishSubject<Void>()
    var exitGameObservable: Observable<Void> { return exitGameOutput.asObserver() }
    
    init() {
        vc = RootViewController(viewControllers: [profileScene.viewController, leaderboardScene.viewController])
        viewController = vc
        presenter = RootPresenter()
        
        profileScene.didLoadObservable.bind(to: vc.didLoadObserver).disposed(by: bag)
        profileScene.exitGameObservable.bind(to: exitGameOutput).disposed(by: bag)
        leaderboardScene.didLoadObservable.bind(to: vc.didLoadObserver).disposed(by: bag)
    }
}
