import UIKit

extension UIButton {
    
    /// Button title for normal state.
    public var em_title: String? {
        get {
            return title(for: UIControlState())
        }
        set(value) {
            setTitle(value, for: UIControlState())
        }
    }
    
    /// Set background color.
    public func em_setBackgroundColor(_ color: UIColor, forState state: UIControlState) {
        setBackgroundImage(color.em_image, for: state)
    }
    
}
