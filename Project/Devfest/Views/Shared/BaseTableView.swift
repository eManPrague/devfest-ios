import UIKit

class BaseTableView: UITableView {

    private(set) var wrapperV: UIView?
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        let name = "\(type(of: subview))".lowercased()
        if name.contains("wrapper") {
            wrapperV = subview
        }
        if name.contains("shadow") {
            subview.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        wrapperV?.subviews.filter({ "\(type(of: $0))".lowercased().contains("shadow") }).forEach({ $0.isHidden = true })
    }

}
