import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    private let bag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private var rootStackView = UIStackView()
    
    // MARK: - Inputs
    
    private let privateKeyInput = ReplaySubject<PrivateKey?>.create(bufferSize: 1)
    var privateKeyObserver: AnyObserver<PrivateKey?> { return privateKeyInput.asObserver() }
    
    private let stateInput = BehaviorSubject<ProfileState>(value: .unknown)
    var stateObserver: AnyObserver<ProfileState> { return stateInput.asObserver() }
    
    private let userViewModelInput = ReplaySubject<UserViewModel>.create(bufferSize: 1)
    var userViewModelObserver: AnyObserver<UserViewModel> { return userViewModelInput.asObserver() }
    
    private let keyPartsInput = ReplaySubject<[PrivateKeyPart]>.create(bufferSize: 1)
    var keyPartsObserver: AnyObserver<[PrivateKeyPart]> { return keyPartsInput.asObserver() }
    
    private let deactivationSequenceInput = ReplaySubject<String>.create(bufferSize: 1)
    var deactivationSequenceObserver: AnyObserver<String> { return deactivationSequenceInput.asObserver() }

    // MARK: - Outputs
    
    private let addKeyOutput = PublishSubject<Void>()
    var addKeyObservable: Observable<Void> { return addKeyOutput.asObservable() }
    
    private let makeSentenceOutput = PublishSubject<Void>()
    var makeSentenceObservable: Observable<Void> { return makeSentenceOutput.asObservable() }
    
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    private let exitGameOutput = PublishSubject<Void>()
    var exitGameObservable: Observable<Void> { return exitGameOutput.asObserver() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = locs("profile.text.header")
        
        // Leave game bar button item
        let exitButton = UIBarButtonItem(image: UIImage(named: "ic_arrow_back"), style: .plain, target: self, action: nil)
        exitButton.rx.tap.bind(to: exitGameOutput).disposed(by: bag)
        navigationItem.leftBarButtonItem = exitButton
        
        // Make and add scroll view
        scrollView.contentInset.bottom = 10
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // ---------- KEYS PART ----------
        
        // Make header for keys status
        let keysHeader = BaseLabel()
        keysHeader.df_setup()
        keysHeader.font = UIFont.df.regular(size: .large)
        keysHeader.textColor = .white
        keysHeader.textAlignment = .center
        
        // Make key button for append new key
        let keysButton = BaseButton(title: locs("profile.button.add_key"))
        keysButton.didTapObservable.bind(to: addKeyOutput).disposed(by: bag)
        
        // Make keys status stack view
        let keysStatusStackView = UIStackView.vertical.space(by: 15).align(by: .center).stack(keysHeader, keysButton)
        
        // Make header for keys status
        let remainingKeysHeader = BaseLabel()
        remainingKeysHeader.textAlignment = .center
        remainingKeysHeader.text = locs("profile.text.remaining_keys.title")
        remainingKeysHeader.df_setup()
        remainingKeysHeader.textColor = .white
        remainingKeysHeader.textAlignment = .center
        
        let remainingKeysStackView = UIStackView.vertical.distribute(by: .fillEqually).space(by: 10).stack()
        let remainingStackView = UIStackView.vertical.space(by: 15).stack(remainingKeysHeader, remainingKeysStackView)
        
        // Bind state changes
        let collectiongCondition = stateInput.map { $0 != .collecting }
        collectiongCondition.bind(to: keysStatusStackView.rx.isHidden).disposed(by: bag)
        collectiongCondition.bind(to: remainingStackView.rx.isHidden).disposed(by: bag)
        
        // ---------- COLLECTED PART ----------

        // Make header for completed keys
        let collectedKeysHeader = BaseLabel()
        collectedKeysHeader.font = UIFont.df.regular(size: .large)
        collectedKeysHeader.text = locs("profile.text.collected_keys.title")
        collectedKeysHeader.df_setup()
        collectedKeysHeader.textColor = .white
        collectedKeysHeader.textAlignment = .center
        
        // Make subheader for completed keys
        let collectedKeysSubheader = BaseLabel()
        collectedKeysSubheader.text = locs("profile.text.collected_keys.subtitle")
        collectedKeysSubheader.df_setup()
        collectedKeysSubheader.textColor = .white
        collectedKeysSubheader.textAlignment = .center
        
        // Make key button for append new key
        let collectedButton = BaseButton(title: locs("profile.button.collected_keys"))
        collectedButton.didTapObservable.bind(to: makeSentenceOutput).disposed(by: bag)
        
        let collectedStackView = UIStackView.vertical.space(by: 15).align(by: .center).stack(collectedKeysHeader, collectedKeysSubheader, collectedButton)
        
        // Bind state changes
        stateInput.map { $0 != .collected }.bind(to: collectedStackView.rx.isHidden).disposed(by: bag)
        
        // ---------- COMPLETED PART ----------
        
        // Make header for completed keys
        let completedKeysHeader = BaseLabel()
        completedKeysHeader.df_setup()
        completedKeysHeader.font = UIFont.df.regular(size: .large)
        completedKeysHeader.textColor = .white
        
        // Make subheader for completed keys
        let completedKeysSubheader = BaseLabel()
        completedKeysSubheader.df_setup()
        completedKeysSubheader.textColor = .white
        completedKeysSubheader.textAlignment = .center
        
        // Make description label for completed keys
        let completedKeysDescription = BaseLabel()
        completedKeysDescription.df_setup()
        completedKeysDescription.textColor = .white
        completedKeysDescription.textAlignment = .center
        
        // Make code view
        let codeView = ProfileCodeView()
        privateKeyInput.bind(to: codeView.privateKeyObserver).disposed(by: bag)

        // Make eman logo view
        let logoView = UIImageView(image: #imageLiteral(resourceName: "img_eman_logo_white"))
        
        // Make title label
        let titleLabel = BaseLabel()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Game developed by eMan"
        
        let brandStackView = UIStackView.vertical.align(by: .center).inset(by: UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)).space(by: 15).stack(logoView, titleLabel)
        stateInput.map { $0 == .top10 || $0 == .completed }.map(!).bind(to: brandStackView.rx.isHidden).disposed(by: bag)
        
        // Make completed stack view
        let completedStackView = UIStackView.vertical.space(by: 15).align(by: .center).stack(completedKeysHeader, completedKeysSubheader, completedKeysDescription, codeView, brandStackView)
        
        // Bind state changes
        stateInput.map { $0 != .top10 && $0 != .completed }.bind(to: completedStackView.rx.isHidden).disposed(by: bag)
        stateInput.map { $0 != .top10 }.bind(to: codeView.rx.isHidden).disposed(by: bag)
        
        stateInput.bind { state in
            completedKeysHeader.text = state == .top10 ? locs("profile.text.top10.title") : locs("profile.text.completed_keys.title")
            completedKeysSubheader.text = state == .top10 ? locs("profile.text.top10.subtitle") : locs("profile.text.completed_keys.subtitle")
            completedKeysDescription.text = state == .top10 ? locs("profile.text.top10.description") : locs("profile.text.completed_keys.description")
        }.disposed(by: bag)
        
        // ---------- FINAL BORING PART ----------
        
        // Make profile view
        let profileView = ProfileView()
        stateInput.map { $0 == .unknown }.bind(to: profileView.rx.isHidden).disposed(by: bag)
        userViewModelInput.bind { viewModel in
            profileView.viewModel = viewModel
            keysHeader.text = viewModel.keysDoneString
        }.disposed(by: bag)
        
        // Make root stack view
        let rootStack = UIStackView.vertical.space(by: 15).stack(
            profileView,
            keysStatusStackView,
            remainingStackView,
            collectedStackView,
            completedStackView
        )
        rootStackView = rootStack
        
        // Add root stack view
        scrollView.addSubview(rootStackView)
        rootStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        // Setup profile view
        profileView.snp.makeConstraints { (make) in
            make.height.equalTo(90)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // Setup code view
        codeView.snp.makeConstraints { $0.width.equalTo(rootStackView.snp.width) }
        
        // Setup buttons
        for button in [keysButton, collectedButton] {
            button.snp.makeConstraints { (make) in
                make.height.equalTo(44)
                make.left.equalToSuperview().offset(25)
                make.right.equalToSuperview().offset(-25)
            }
        }
        
        // State update
        stateInput.map { _ in () }.subscribe(onNext: scrollView.layoutIfNeeded).disposed(by: bag)
        
        // Key parts update
        keyPartsInput.map({ $0.map({ m in ProfileKeyView(model: m) }) }).subscribe(onNext: { views in
            let currentViews = remainingKeysStackView.arrangedSubviews
            currentViews.forEach { v in
                remainingKeysStackView.removeArrangedSubview(v)
                v.removeFromSuperview()
            }
            views.forEach { remainingKeysStackView.addArrangedSubview($0) }
            views.forEach { v in
                v.snp.makeConstraints { (make) in
                    make.width.equalTo(rootStack.snp.width)
                    make.height.equalTo(40)
                }
            }
            rootStack.layoutIfNeeded()
        }).disposed(by: bag)
        didLoadOutput.onNext()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = rootStackView.bounds.size
    }
}
