import Foundation
import RxSwift

class LeaderboardPresenter {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let viewModelsOutput = ReplaySubject<[UserViewModel]>.create(bufferSize: 1)
    var viewModelsObservable: Observable<[UserViewModel]> { return viewModelsOutput.asObservable() }
    
    init() {
        GameDataManager.shared.usersObservable.map { $0.map { user in UserViewModel(model: user) } }.bind(to: viewModelsOutput).disposed(by: bag)
    }
}
