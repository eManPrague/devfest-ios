import Foundation
import UIKit
import RxSwift

class MapScene: Scene {
    // MARK: Public
    
    var viewController: UIViewController { return vc }
    
    // MARK: Private
    private let bag = DisposeBag()
    private let vc = MapViewController()
    
    // MARK: Inputs
    
    // MARK: Outputs
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    // MARK: Lifecycle
    init() {
        vc.didLoadObservable.bind(to: didLoadOutput).disposed(by: bag)
    }
    
    // MARK: Public funcs
    
    // MARK: Private funcs
}
