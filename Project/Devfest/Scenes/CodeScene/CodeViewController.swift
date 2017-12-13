import UIKit
import RxSwift

class CodeViewController: BaseViewController {
    
    private let bag = DisposeBag()
    
    // MARK: - Inputs
    
    private let keyPartInput = PublishSubject<String>()
    var keyPartObserver: AnyObserver<String> { return keyPartInput.asObserver() }
    
    private let keyPartStateInput = PublishSubject<KeyPartType>()
    var keyPartStateObserver: AnyObserver<KeyPartType> { return keyPartStateInput.asObserver() }
    
    // MARK: - Outputs
    
    private let characterOutput = PublishSubject<String>()
    var characterObservable: Observable<String> { return characterOutput.asObservable() }
    
    private let clearOutput = PublishSubject<Void>()
    var clearObservable: Observable<Void> { return clearOutput.asObservable() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = locs("key_part_add.text.header")
        
        let popButton = UIBarButtonItem(image: UIImage(named: "ic_arrow_back"), style: .plain, target: self, action: nil)
        popButton.rx.tap.bind { [unowned self] in self.navigationController?.popViewController(animated: true) }.disposed(by: bag)
        navigationItem.leftBarButtonItem = popButton
        
        // Make and add code keyboard view
        let keyboardView = CodeKeyboardView()
        keyboardView.characterObservable.bind(to: characterOutput).disposed(by: bag)
        keyboardView.clearObservable.bind(to: clearOutput).disposed(by: bag)
        view.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // Make and add key part label
        let keyPartView = KeyPartView()
        CodeActivationManager.shared.enableObservable.map(!).bind(to: keyPartView.rx.isHidden).disposed(by: bag)
//        keyPartStateInput.map { $0 == .invalid }.bind(to: keyPartView.rx.isHidden).disposed(by: bag)
        keyPartInput.bind(to: keyPartView.keyPartObserver).disposed(by: bag)
        view.addSubview(keyPartView)
        keyPartView.snp.makeConstraints { (make) in
            make.centerY.equalTo(keyboardView.snp.top).dividedBy(2)
            make.centerX.equalToSuperview()
        }
        
        // Make and add wrong key part label
        let incorrectLabel = BaseLabel()
        incorrectLabel.text = locs("key_part_add.text.wrong")
        incorrectLabel.textColor = .white
        
        let remainingTimeLabel = BaseLabel()
        remainingTimeLabel.textColor = .white
        CodeActivationManager.shared.remainigObservable.map { "\($0) \(locs("key_part_add.text.seconds"))." }.bind(to: remainingTimeLabel.rx.text).disposed(by: bag)
        
        let incorrectStackView = UIStackView.vertical.align(by: .center).stack(incorrectLabel, remainingTimeLabel)
        incorrectStackView.isHidden = true
        CodeActivationManager.shared.enableObservable.bind(to: incorrectStackView.rx.isHidden).disposed(by: bag)
//        keyPartStateInput.map { $0 == .invalid }.map(!).bind(to: incorrectStackView.rx.isHidden).disposed(by: bag)
        view.addSubview(incorrectStackView)
        incorrectStackView.snp.makeConstraints { (make) in
            make.center.equalTo(keyPartView.snp.center)
        }

        let alreadyUnlcokedLabel = BaseLabel()
        alreadyUnlcokedLabel.isHidden = true
        
        keyPartStateInput.map { $0 == .alreadyUnlocked }.map(!).bind(to: alreadyUnlcokedLabel.rx.isHidden).disposed(by: bag)
        alreadyUnlcokedLabel.textColor = .white
        alreadyUnlcokedLabel.adjustsFontSizeToFitWidth = true
        alreadyUnlcokedLabel.text = locs("key_part_add.text.already_unlocked")
        view.addSubview(alreadyUnlcokedLabel)
        alreadyUnlcokedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(keyPartView.snp.bottom)
            make.bottom.equalTo(keyboardView.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        // Bind
        keyPartStateInput.asVoid().bind(to: clearOutput).disposed(by: bag)
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
}
