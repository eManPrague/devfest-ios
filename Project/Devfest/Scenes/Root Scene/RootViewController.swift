import UIKit
import RxSwift

class RootViewController: UITabBarController {
    
    private let bag = DisposeBag()
    private let touchesBegan = PublishSubject<(touch: UITouch, view: UIView)>()
    
    // MARK: - Inputs
    
    private let didLoadInput = PublishSubject<Void>()
    var didLoadObserver: AnyObserver<Void> { return didLoadInput.asObserver() }
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup native tab bar
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        // Add and setup tab bar container
        let tabBarContainer = UIView()
        tabBarContainer.backgroundColor = .black
        tabBar.addSubview(tabBarContainer)
        tabBarContainer.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        didLoadInput.map { tabBarContainer }.subscribe(onNext: removeTabBarItems).disposed(by: bag)
        
        // Create buttons
        let buttons = [
            TabButton(title: locs("tabs.button.profile"), index: 0),
            TabButton(title: locs("tabs.button.leaderboard"), index: 1)
        ]
        
        // Setup tab buttons
        for (index, button) in buttons.enumerated() {
            button.isSelected = index == 0
            button.rx.tap.map { (button.index, buttons) }.subscribe(onNext: select).disposed(by: bag)
            button.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: index == 0 ? -20 : 20,
                bottom: 0,
                right: index == 0 ? 20 : -20
            )
        }

        // Make and add buttons
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.backgroundColor = .black
        tabBarContainer.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        // Bind additional touch outside
        touchesBegan.filter { $0.view.isDescendant(of: tabBarContainer) }.map { touch, view -> (Int, [TabButton]) in
            let location = touch.location(in: tabBarContainer)
            let index = location.x < view.bounds.width / 2 ? 0 : buttons.count-1
            return (index, buttons)
        }.subscribe(onNext: select).disposed(by: bag)
    }
    
    private func select(at index: Int, by buttons: [TabButton]) {
        selectedViewController = viewControllers?[index]
        buttons.forEach { $0.isSelected = $0.index == index }
    }
    
    private func removeTabBarItems(exlude: UIView) {
        tabBar.subviews.filter { $0 != exlude }.forEach { $0.removeFromSuperview() }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view = touch.view else { return }
        touchesBegan.onNext((touch, view))
    }
}
