import UIKit

extension UIViewController {
    
    /// Add child view controller and all the jazz around it.
    public func em_appendChildVC(_ vc: UIViewController, toView view: UIView, autoresize: Bool) {
        addChildViewController(vc)
        
        view.addSubview(vc.view)
        
        if autoresize {
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            let lc = { (attr: NSLayoutAttribute) -> NSLayoutConstraint in
                return NSLayoutConstraint(item: vc.view, attribute: attr, relatedBy: .equal, toItem: view, attribute: attr, multiplier: 1, constant: 0)
            }
            
            view.addConstraints([lc(.top), lc(.right), lc(.bottom), lc(.left)])
        }
        
        vc.didMove(toParentViewController: self)
    }
    
    /// Remove child view controller and all the jazz around it.
    public func em_removeChildVC(_ vc: UIViewController) {
        vc.view.removeFromSuperview()
        vc.willMove(toParentViewController: nil)
        vc.removeFromParentViewController()
    }
    
    public func showAlert(title: String, message: String) {
        let okAction = UIAlertAction(title: locs("general.buttons.ok"), style: .default, handler: nil)
        showAlert(title: title, message: message, actions: [okAction], preferredAction: nil)
    }
    
    public func showAlert(title: String, message: String, actions: [UIAlertAction], preferredAction: UIAlertAction?) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { vc.addAction($0) }
        if let pa = preferredAction {
            vc.preferredAction = pa
        }
        present(vc, animated: true, completion: nil)
    }
    
}
