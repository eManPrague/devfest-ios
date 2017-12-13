import UIKit
import RxSwift

class LeaderboardNavigationScene: NavigationScene {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    init() {
        let scene = LeaderboardScene()
        super.init(rootScene: scene, navigationController: BaseNavigationController(rootViewController: scene.viewController))
        
        scene.didLoadObservable.bind(to: didLoadOutput).disposed(by: bag)
    }
}
