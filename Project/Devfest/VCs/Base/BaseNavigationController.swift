import UIKit

class BaseNavigationController: UINavigationController, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .df_background
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                             NSFontAttributeName:UIFont.df.regular(size: .normal)]
        view.backgroundColor = .df_background
    }
    
    // MARK: UINavigationController Delegate
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
