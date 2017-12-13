import UIKit
import RxSwift

class SentenceScene: Scene {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let submitOutput = PublishSubject<Void>()
    var submitObservable: Observable<Void> { return submitOutput.asObservable() }
    
    private let presenter: SentencePresenter
    private let vc: SentenceViewController
    var viewController: UIViewController
    
    init() {
        vc = SentenceViewController()
        viewController = vc
        presenter = SentencePresenter()
        
        vc.submitObservable.bind(to: presenter.keyPartsObserver).disposed(by: bag)
        
        presenter.modelsObservable.bind(to: vc.modelsObserver).disposed(by: bag)
        presenter.correctObservable.bind(to: submitOutput).disposed(by: bag)
        presenter.wrongObservable.bind(to: vc.wrongObserver).disposed(by: bag)
        presenter.disconnectedObservable.bind(to: vc.disconnectedObserver).disposed(by: bag)

        
//        presenter.submitResultObservable.subscribe(onNext: { result in
//            let man = GameDataManager.shared
//            // Check connection to Firebase database before doing anything else
//            if let u = man.currentUser, man.isConnected {
//                // Cool, we have a connection -> save new order of user's key parts
//                // TODO: SN: Unfortunately the database does not persis ordering :-/
//                let newParts = result.1
//                let usersEntries = man.progressEntries(forUserID: u.key)
//                let orderedEntries = newParts.flatMap({ newPart in usersEntries.first(where: { e in e.keyID == newPart.key }) })
//                man.update(progressEntries: orderedEntries, forUserID: u.key, completion: {
//                    if (result.0 == true) {
//                        // The order was correct
//                        man.markSentenceCompleted(forUserID: u.key, completion: { [weak self] in
//                            self?.submitOutput.onNext()
//                        })
//                    } else {
//                        // The order was incorrect
//                        sentenceVC.wrongSubmitObserver.onNext()
//                    }
//                })
//            } else {
//                // No connection to Firebase
//                sentenceVC.showAlert(title: locs("network.error.alert_title"), message: locs("network.error.no_connection_to_firebase"))
//            }
//        }).disposed(by: bag)
    }
}
