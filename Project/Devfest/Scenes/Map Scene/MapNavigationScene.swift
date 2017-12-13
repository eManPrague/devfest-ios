import Foundation
import RxSwift

class MapNavigationScene: NavigationScene {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    private let exitGameOutput = PublishSubject<Void>()
    var exitGameObservable: Observable<Void> { return exitGameOutput.asObserver() }
    
    init() {
        // Root scene
        let scene = MapScene()
        super.init(rootScene: scene, navigationController: MapNavigationViewController(rootViewController: scene.viewController))
        // Bindings
        scene.didLoadObservable.bind(to: didLoadOutput).disposed(by: bag)
    }
}
