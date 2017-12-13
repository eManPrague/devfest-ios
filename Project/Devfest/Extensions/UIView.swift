import UIKit

extension UIView {
    
    public static var em_nibName: String {
        let components = NSStringFromClass(self).components(separatedBy: ".")
        return components[components.count - 1]
    }
    
    public static var em_nib: UINib {
        return UINib(nibName: em_nibName, bundle: nil)
    }
    
    public static var em_reuseIdentifier: String {
        return NSStringFromClass(self)
    }
    
    /// Load custom UIView subclass from nib.
    ///
    /// Usage:
    ///
    ///     let n: CustomView = CustomView.em_nibInstance()
    public class func em_nibInstance<T>() -> T {
        let array = em_nib.instantiate(withOwner: nil, options: nil)
        return array.first as! T
    }
    
    class NNU: UIView {
        
    }
    
    public var em_firstResponder: UIView? {
        if self.isFirstResponder {
            return self
        } else {
            for view in subviews {
                if let fr = view.em_firstResponder {
                    return fr
                }
            }
        }
        
        return nil
    }
    
    public func em_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, self.contentScaleFactor)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
}
