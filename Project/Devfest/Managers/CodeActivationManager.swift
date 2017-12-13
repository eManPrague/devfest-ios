import Foundation
import RxSwift

class CodeActivationManager {
    
    private let bag = DisposeBag()
    private var timer: Timer?
    
    private var timestampNow: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    private var timestampToReach: TimeInterval {
        get { return UserDefaults.standard.double(forKey: "timestampToReach") }
        set {
            UserDefaults.standard.set(newValue, forKey: "timestampToReach")
            UserDefaults.standard.synchronize()
        }
    }
    
    private var time: Double {
        get { return UserDefaults.standard.double(forKey: "time") }
        set {
            UserDefaults.standard.set(newValue, forKey: "time")
            UserDefaults.standard.synchronize()
        }
    }
    
    static let shared = CodeActivationManager()
    
    // Outputs
    
    private let enableOutput = BehaviorSubject<Bool>(value: true)
    var enableObservable: Observable<Bool> { return enableOutput.asObservable() }
    
    private let remainigOutput = ReplaySubject<Int>.create(bufferSize: 1)
    var remainigObservable: Observable<Int> { return remainigOutput.asObservable() }
    
    // Inputs
    
    private let incrementInput = PublishSubject<Void>()
    var incrementObserver: AnyObserver<Void> { return incrementInput.asObserver() }
    
    private let clearInput = PublishSubject<Void>()
    var clearObserver: AnyObserver<Void> { return clearInput.asObserver() }
    
    func start() {
        if timestampToReach > timestampNow {
            self.startTimer(on: timestampToReach - timestampNow)
        }
    }
    
    init() {
        incrementInput.bind { [unowned self] in
            let time = self.time == 0 ? 1 : self.time * 2
            self.time = time
            self.timestampToReach = self.timestampNow + time
            self.startTimer(on: time)
        }.disposed(by: bag)

        clearInput.bind { [unowned self] in self.time = 0 }.disposed(by: bag)
        remainigOutput.map { $0 == 0 }.bind(to: enableOutput).disposed(by: bag)
    }
    
    private func startTimer(on time: Double) {
        self.remainigOutput.onNext(Int(time))
        self.stopTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func update() {
        let time = Int(ceil(timestampToReach - timestampNow))

        if time <= 0 {
            remainigOutput.onNext(0)
            stopTimer()
        } else {
            remainigOutput.onNext(time)
        }
    }
}
