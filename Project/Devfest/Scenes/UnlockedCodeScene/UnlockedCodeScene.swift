import UIKit
import RxSwift

class UnlockedCodeScene: Scene {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    private let doneOutput = PublishSubject<Void>()
    var doneObservable: Observable<Void> { return doneOutput.asObservable() }
    
    private let presenter: UnlockedCodePresenter
    private let vc: UnlockedCodeViewController
    var viewController: UIViewController
    
    init(keyPart: PrivateKeyPart) {
        vc = UnlockedCodeViewController()
        viewController = vc
        presenter = UnlockedCodePresenter(keyPart: keyPart)
        
        vc.doneObservable.bind(to: doneOutput).disposed(by: bag)
        presenter.keyPartObserver.bind(to: vc.keyPartObserver).disposed(by: bag)
    }
}
