import UIKit
import RxSwift

class LeaderboardScene: Scene {
    
    private let bag = DisposeBag()

    // MARK: - Outputs
    
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    private let presenter: LeaderboardPresenter
    private let vc: LeaderboardViewController
    var viewController: UIViewController
    
    init() {
        vc = LeaderboardViewController()
        viewController = vc
        presenter = LeaderboardPresenter()
        
        vc.didLoadObservable.bind(to: didLoadOutput).disposed(by: bag)
        
        presenter.viewModelsObservable.bind(to: vc.modelsObserver).disposed(by: bag)
    }
}
