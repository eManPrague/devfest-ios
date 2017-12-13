import UIKit

/// Base View that every view should inherit from.
class BaseView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Entry point for subclasses to participate in UI setup.
    public func setupUI() {}
    
}
