import Foundation
import RxSwift

extension Observable {
    
    func asVoid() -> Observable<Void> {
        return self.map { _ in () }
    }
}
