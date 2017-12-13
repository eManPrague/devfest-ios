import Foundation
import RxSwift

class SentencePresenter {
    
    private let bag = DisposeBag()
    
    // MARK: - Inputs
    
    private let keyPartsInput = PublishSubject<[PrivateKeyPart]>()
    var keyPartsObserver: AnyObserver<[PrivateKeyPart]> { return keyPartsInput.asObserver() }
    
    // MARK: - Outputs
    
    private let modelsOutput = ReplaySubject<[PrivateKeyPart]>.create(bufferSize: 1)
    var modelsObservable: Observable<[PrivateKeyPart]> { return modelsOutput.asObserver() }
    
    private let correctOutput = PublishSubject<Void>()
    var correctObservable: Observable<Void> { return correctOutput.asObservable() }
    
    private let wrongOutput = PublishSubject<Void>()
    var wrongObservable: Observable<Void> { return wrongOutput.asObservable() }
    
    private let disconnectedOutput = PublishSubject<Void>()
    var disconnectedObservable: Observable<Void> { return disconnectedOutput.asObservable() }
    
    init() {
        GameDataManager.shared.currentUserObservable.map(models).take(1).subscribe(onNext: modelsOutput.onNext).disposed(by: bag)
        keyPartsInput.map(evaluate).map(submit).subscribe(onNext: output).disposed(by: bag)
    }
    
    private func models(for user: User) -> [PrivateKeyPart] {
        let progress = GameDataManager.shared.progressEntries(forUserID: user.key)
        let privateKeyParts = GameDataManager.shared.privateKeyParts
        
        return progress.map { progress in
            privateKeyParts.first(where: { $0.key == progress.keyID })!
        }
    }
    
    private func evaluate(by keyParts: [PrivateKeyPart]) -> (Bool, [PrivateKeyPart]) {
        let privateKeySequence = GameDataManager.shared.privateKey?.sequence
        let userPrivateKeySequence = keyParts.map { $0.key }.joined()
        let isCorrect = privateKeySequence == userPrivateKeySequence
        
        return (isCorrect, keyParts)
    }
    
    private func submit(result: (isCorrect: Bool, newKeyParts: [PrivateKeyPart])) -> Observable<SubmitState> {
        return Observable.create { observer in
            guard let user = GameDataManager.shared.currentUser else { return Disposables.create() }

            if GameDataManager.shared.isConnected {
                let orderedEntries = result.newKeyParts.flatMap { keyParts in
                    GameDataManager.shared.progressEntries(forUserID: user.key).first(where: { $0.keyID == keyParts.key })
                }
                
                guard result.isCorrect else { observer.onNext(.wrong); return Disposables.create() }
                
                GameDataManager.shared.update(progressEntries: orderedEntries, forUserID: user.key) {
                    GameDataManager.shared.markSentenceCompleted(forUserID: user.key) {
                        observer.onNext(.correct)
                    }
                }
            } else {
                observer.onNext(.disconnected)
            }
            
            return Disposables.create()
        }
    }
    
    private func output(of submit: Observable<SubmitState>) {
        submit.filter { $0 == .correct }.asVoid().bind(to: correctOutput).disposed(by: bag)
        submit.filter { $0 == .wrong }.asVoid().bind(to: wrongOutput).disposed(by: bag)
        submit.filter { $0 == .disconnected }.asVoid().bind(to: disconnectedOutput).disposed(by: bag)
    }
}

enum SubmitState {
    case correct
    case wrong
    case disconnected
}
