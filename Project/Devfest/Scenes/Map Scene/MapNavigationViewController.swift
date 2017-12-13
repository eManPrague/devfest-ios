import UIKit

class MapNavigationViewController: BaseNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.shadowImage = nil
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .rddDefaultColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

}
