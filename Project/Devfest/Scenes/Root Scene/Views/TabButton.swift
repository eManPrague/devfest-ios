import UIKit

class TabButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            updateTitle()
        }
    }
    
    let index: Int
    private let title: String

    init(title: String, index: Int) {
        self.index = index
        self.title = title
        
        super.init(frame: .zero)
        updateTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTitle() {
        let color = isSelected ? UIColor.df_lightBlue : UIColor.df_green
        let underlineStyle = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleNone.rawValue
        let a = [
            NSFontAttributeName: UIFont.df.regular(size: .normal),
            NSForegroundColorAttributeName: color,
            NSUnderlineStyleAttributeName: underlineStyle,
            NSUnderlineColorAttributeName: color
        ] as [String : Any]
        setAttributedTitle(NSAttributedString(string: title.uppercased(), attributes: a), for: .normal)
    }
}
