import UIKit
import RxSwift

class ProfileScene: Scene {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let addKeyOutput = PublishSubject<Void>()
    var addKeyObservable: Observable<Void> { return addKeyOutput.asObservable() }
    
    private let makeSentenceOutput = PublishSubject<Void>()
    var makeSentenceObservable: Observable<Void> { return makeSentenceOutput.asObservable() }
    
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    private let exitGameOutput = PublishSubject<Void>()
    var exitGameObservable: Observable<Void> { return exitGameOutput.asObserver() }
    
    private let presenter: ProfilePresenter
    private let vc: ProfileViewController
    var viewController: UIViewController
    
    init() {
        vc = ProfileViewController()
        viewController = vc
        presenter = ProfilePresenter()
        
        vc.addKeyObservable.bind(to: addKeyOutput).disposed(by: bag)
        vc.makeSentenceObservable.bind(to: makeSentenceOutput).disposed(by: bag)
        vc.didLoadObservable.bind(to: didLoadOutput).disposed(by: bag)
        vc.exitGameObservable.bind(to: exitGameOutput).disposed(by: bag)
        
        presenter.privateKeyObservable.bind(to: vc.privateKeyObserver).disposed(by: bag)
        presenter.stateObservable.bind(to: vc.stateObserver).disposed(by: bag)
        presenter.userViewModelObservable.bind(to: vc.userViewModelObserver).disposed(by: bag)
        presenter.keyPartsObservable.bind(to: vc.keyPartsObserver).disposed(by: bag)
    }
    
}
