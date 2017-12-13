import UIKit
import SnapKit

/// Base VC that every VC should inherit from.
class BaseViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .fade }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Log.debug("\(string(fromClass: self.self)) did appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .df_background
    }
}
