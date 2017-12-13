import UIKit
import RxSwift

class CodeScene: Scene {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let keyUnlockedOutput = PublishSubject<PrivateKeyPart>()
    var keyUnlockedObservable: Observable<PrivateKeyPart> { return keyUnlockedOutput.asObservable() }
    
    private let presenter: CodePresenter
    private let vc: CodeViewController
    var viewController: UIViewController
    
    init() {
        vc = CodeViewController()
        viewController = vc
        presenter = CodePresenter()
        
        // Bind single tap on any character on keyboard
        vc.characterObservable.bind(to: presenter.characterObserver).disposed(by: bag)
        vc.clearObservable.bind(to: presenter.clearObserver).disposed(by: bag)
        
        // Bind ready key part to view controller
        presenter.keyPartObservable.bind(to: vc.keyPartObserver).disposed(by: bag)
        presenter.keyPartStateObservable.bind(to: vc.keyPartStateObserver).disposed(by: bag)
        presenter.keyUnlockedObservable.bind(to: keyUnlockedOutput).disposed(by: bag)
        
//        let eval = presenter.keyPartEvaluationObservable.map({ (eval) -> (String?, PrivateKeyPart?) in
//            switch eval {
//            case .invalid(let reason), .alreadyUnlocked(_, let reason): return (reason, nil)
//            case .valid(let part): return (nil, part)
//            }
//        }).share()
        
        
        
//        let eval = presenter.keyPartEvaluationObservable.shareReplay(1)
//        
//        eval.filter { $0.part != nil }.map { $0.part! }.bind(to: keyUnlockedOutput).disposed(by: bag)
//        eval.map { $0.reason }.bind(to: vc.keyPartEvaluationObserver).disposed(by: bag)
    }
}
