import UIKit

class SentenceCell: UITableViewCell {
    
    private let sentenceView = SentenceView(dragable: true)
    
    var model: PrivateKeyPart? {
        didSet {
            sentenceView.model = model
        }
    }
    
    override var alpha: CGFloat {
        didSet {
            // :D this is the most compatible solution I could come up with
            if String(format: "%.1f", alpha) < "0.9" {
                alpha = oldValue
                UIView.animate(withDuration: 0.15, animations: { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                })
            } else {
                UIView.animate(withDuration: 0.15, animations: { [weak self] in
                    self?.transform = .identity
                })
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        contentView.addSubview(sentenceView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sentenceView.frame = CGRect(x: 15, y: 0, width: bounds.width-30, height: 63)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        model = nil
    }
}
