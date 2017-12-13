
import UIKit

extension UIStackView {
    
    class Maker {
        
        private let stackView = UIStackView()
        
        init(axis: UILayoutConstraintAxis) {
            stackView.axis = axis
        }
        
        func align(by alignment: UIStackViewAlignment) -> Maker {
            stackView.alignment = alignment
            return self
        }
        
        func distribute(by distribution: UIStackViewDistribution) -> Maker {
            stackView.distribution = distribution
            return self
        }
        
        func space(by spacing: CGFloat) -> Maker {
            stackView.spacing = spacing
            return self
        }
        
        func inset(by insets: UIEdgeInsets) -> Maker {
            stackView.layoutMargins = insets
            return self.withLayoutMarginsRelativeArrangement
        }
        
        var withLayoutMarginsRelativeArrangement: Maker {
            stackView.isLayoutMarginsRelativeArrangement = true
            return self
        }
        
        var withBaselineRelativeArrangement: Maker {
            stackView.isBaselineRelativeArrangement = true
            return self
        }
        
        func stack(_ views: UIView...) -> UIStackView {
            for view in views {
                stackView.addArrangedSubview(view)
            }
            
            return stackView
        }
        
    }
    
    static var horizontal: Maker { return Maker(axis: .horizontal) }
    static var vertical: Maker { return Maker(axis: .vertical) }
    
}
