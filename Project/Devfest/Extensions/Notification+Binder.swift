import Foundation
import RxSwift
import RxCocoa

public extension Notification.Name {
    
    public func bind(_ next: @escaping (Notification) -> Void) -> Disposable {
        return NotificationCenter.default.rx.notification(self).bind{ sender in
            next(sender)
        }
    }
    
    public func asObservable() -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(self)
    }
    
    public func mapVoid() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(self).map { _ in () }
    }
}
