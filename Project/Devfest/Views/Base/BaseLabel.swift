import UIKit

class BaseLabel: UILabel {
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
    public func setupUI() {
        font = UIFont.df.regular(size: .normal)
        textColor = UIColor.df_green
    }
}
