import UIKit
import RxSwift

class UnlockedCodeViewController: BaseViewController {
    
    private let bag = DisposeBag()
    
    // MARK: - Inputs
    
    private let keyPartInput = ReplaySubject<PrivateKeyPart?>.create(bufferSize: 1)
    var keyPartObserver: AnyObserver<PrivateKeyPart?> { return keyPartInput.asObserver() }
    
    // MARK: - Outputs
    
    private let doneOutput = PublishSubject<Void>()
    var doneObservable: Observable<Void> { return doneOutput.asObservable() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        // Make unlocked image view
        let unlockedImageView = UIImageView(image: UIImage(named: "ic_unlocked"))
        
        // Make title label
        let titleLabel = BaseLabel()
        titleLabel.font = UIFont.df.regular(size: .large)
        titleLabel.text = locs("key_part_added.text.title")
        titleLabel.df_setup()
        titleLabel.font = UIFont.df.regular(size: .large)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        // Make subtitle label
        let subtitleLabel = BaseLabel()
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = locs("key_part_added.text.subtitle")
        subtitleLabel.df_setup()
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        
        // Make and add sentence view
        let sentenceView = SentenceView()
        keyPartInput.bind { model in sentenceView.model = model }.disposed(by: bag)
        
        // Make continue label
        let continueButton = BaseButton(title: locs("key_part_added.button.continue"))
        continueButton.didTapObservable.bind(to: doneOutput).disposed(by: bag)
        
        // Make root stack view
        let rootStackView = UIStackView.vertical.align(by: .center).space(by: 30).stack(
            unlockedImageView,
            UIStackView.vertical.align(by: .center).space(by: 10).stack(
                titleLabel,
                subtitleLabel
            ),
            sentenceView,
            continueButton
        )
        
        // Add and setup root stack view
        view.addSubview(rootStackView)
        rootStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-64)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // Setup sentence view
        sentenceView.snp.makeConstraints { (make) in
            make.height.equalTo(63)
            make.width.equalTo(view.snp.width).offset(-40)
        }
        
        // Setup continue button
        continueButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(view.snp.width).offset(-80)
        }
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
}
