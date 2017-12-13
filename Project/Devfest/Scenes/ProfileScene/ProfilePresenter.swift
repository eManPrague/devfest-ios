import Foundation
import RxSwift

class ProfilePresenter {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let privateKeyOutput = ReplaySubject<PrivateKey?>.create(bufferSize: 1)
    var privateKeyObservable: Observable<PrivateKey?> { return privateKeyOutput.asObservable() }
    
    private let stateOutput = Variable<ProfileState>(.unknown)
    var stateObservable: Observable<ProfileState> { return stateOutput.asObservable() }
    
    private let userViewModelOutput = ReplaySubject<UserViewModel>.create(bufferSize: 1)
    var userViewModelObservable: Observable<UserViewModel> { return userViewModelOutput.asObserver() }
    
    private let keyPartsOutput = ReplaySubject<[PrivateKeyPart]>.create(bufferSize: 1)
    var keyPartsObservable: Observable<[PrivateKeyPart]> { return keyPartsOutput.asObserver() }
    
    init() {
        let currentUserObservable = GameDataManager.shared.currentUserObservable.map(UserViewModel.init)
        currentUserObservable.map(state).bind(to: stateOutput).disposed(by: bag)
        currentUserObservable.bind(to: userViewModelOutput).disposed(by: bag)
        currentUserObservable.map(remainingKeyParts).bind(to: keyPartsOutput).disposed(by: bag)
        
        GameDataManager.shared.privateKeyObservable.bind(to: privateKeyOutput).disposed(by: bag)
    }
    
    private func state(for user: UserViewModel) -> ProfileState {
        guard user.hasAllKeysDone else { return .collecting }
        guard user.solvedTimestamp.intValue > 0 else { return .collected }
        
        if GameDataManager.shared.users.prefix(10).contains(where: { $0.key == user.id}) {
            return .top10
        }
        
        return .completed
    }
    
    private func remainingKeyParts(for user: UserViewModel) -> [PrivateKeyPart] {
        return GameDataManager.shared.remainingKeyParts(forUserID: user.id)
    }
}

enum ProfileState {
    case collecting
    case collected
    case top10
    case completed
    case unknown
}
