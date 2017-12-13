import Foundation
import RxSwift

class ProfileNavigationScene: NavigationScene {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    private let exitGameOutput = PublishSubject<Void>()
    var exitGameObservable: Observable<Void> { return exitGameOutput.asObserver() }
    
    init() {
        let scene = ProfileScene()
        
        super.init(rootScene: scene, navigationController: BaseNavigationController(rootViewController: scene.viewController))
        
        scene.exitGameObservable.bind(to: exitGameOutput).disposed(by: bag)
        scene.addKeyObservable.subscribe(onNext: pushCodeScene).disposed(by: bag)
        scene.makeSentenceObservable.subscribe(onNext: pushSentenceScene).disposed(by: bag)
        scene.didLoadObservable.bind(to: didLoadOutput).disposed(by: bag)
    }
    
    private func pushCodeScene() {
        let scene = CodeScene()
        scene.keyUnlockedObservable.subscribe(onNext: setUnlockedCodeScene).disposed(by: bag)
        push(scene: scene)
    }
    
    private func pushSentenceScene() {
        let scene = SentenceScene()
        scene.submitObservable.subscribe(onNext: setProfileScene).disposed(by: bag)
        push(scene: scene)
    }
    
    private func setUnlockedCodeScene(keyPart: PrivateKeyPart) {
        let scene = UnlockedCodeScene(keyPart: keyPart)
        scene.doneObservable.subscribe(onNext: setProfileScene).disposed(by: bag)
        setScenes(scenes: [scene], animated: true)
    }
    
    private func setProfileScene() {
        let scene = ProfileScene()
        scene.exitGameObservable.bind(to: exitGameOutput).disposed(by: bag)
        scene.addKeyObservable.subscribe(onNext: pushCodeScene).disposed(by: bag)
        scene.makeSentenceObservable.subscribe(onNext: pushSentenceScene).disposed(by: bag)
        scene.didLoadObservable.bind(to: didLoadOutput).disposed(by: bag)
        setScenes(scenes: [scene], animated: true)
    }
}
