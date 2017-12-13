import Foundation
import RxSwift

class UnlockedCodePresenter {

    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let keyPartOutput = ReplaySubject<PrivateKeyPart?>.create(bufferSize: 1)
    var keyPartObserver: Observable<PrivateKeyPart?> { return keyPartOutput.asObservable() }
    
    init(keyPart: PrivateKeyPart) {
        
        Observable.just(keyPart).bind(to: keyPartOutput).disposed(by: bag)
    }
}
