import Foundation
import RxSwift

enum KeyPartType {
    case invalid
    case alreadyUnlocked
    case valid
}

struct KeyPart {
    let type: KeyPartType
    let part: PrivateKeyPart?
}

class CodePresenter {
    
    private let bag = DisposeBag()
    
    // MARK: - Inputs
    
    private let characterInput = PublishSubject<String>()
    var characterObserver: AnyObserver<String> { return characterInput.asObserver() }
    
    private let clearInput = PublishSubject<Void>()
    var clearObserver: AnyObserver<Void> { return clearInput.asObserver() }
    
    // MARK: - Outputs
    
    private let keyPartOutput = Variable<String>("")
    var keyPartObservable: Observable<String> { return keyPartOutput.asObservable() }
    
    private let keyUnlockedOutput = PublishSubject<PrivateKeyPart>()
    var keyUnlockedObservable: Observable<PrivateKeyPart> { return keyUnlockedOutput.asObservable() }
    
    private let keyPartStateOutput = PublishSubject<KeyPartType>()
    var keyPartStateObservable: Observable<KeyPartType> { return keyPartStateOutput.asObservable() }
    
    init() {
        
        let keyPart = characterInput.map(append).share()
        keyPart.bind(to: keyPartOutput).disposed(by: bag) // Chars
        
        let complete = keyPart.filter({ $0.characters.count == 2 }).map(evaluate).share()
        let valid = complete.filter { $0.type == .valid }.share()
        valid.map { $0.part }.filterNil().bind(to: keyUnlockedOutput).disposed(by: bag)
        valid.asVoid().bind(to: CodeActivationManager.shared.clearObserver).disposed(by: bag)
        
        complete.filter { $0.type != .valid }.map { $0.type }.bind(to: keyPartStateOutput).disposed(by: bag)
        complete.filter { $0.type == .invalid }.asVoid().bind(to: CodeActivationManager.shared.incrementObserver).disposed(by: bag)
        
        clearInput.map {""}.bind(to: keyPartOutput).disposed(by: bag)
    }
    
    private func append(character: String) -> String {
        guard keyPartOutput.value.characters.count < 2 else { return keyPartOutput.value }
        return keyPartOutput.value.appending(character)
    }
    
    private func evaluate(keyPartKey: String) -> KeyPart {
        let manager = GameDataManager.shared
        
        guard
            let keyPart = manager.privateKeyParts.first(where: { $0.key == keyPartKey }),
            let user = manager.currentUser
        else {
            return KeyPart(type: .invalid, part: nil)
        }
        
        // Already unlocked
        if manager.progressEntries(forUserID: user.key).first(where: { $0.keyID == keyPart.key }) != nil {
            return KeyPart(type: .alreadyUnlocked, part: nil)
        }
        
        // Valid
        manager.saveIfNeeded(keyPartID: keyPartKey, forUser: user, completion: nil)
        return KeyPart(type: .valid, part: keyPart)
    }
}
