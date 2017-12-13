import UIKit

class SentenceView: NeverChangingBackgroundView {
    
    private let iconImageView = UIImageView(image: UIImage(named: "ic_key_small"))
    private let keyLabel = BaseLabel()
    private let sentenceLabel = BaseLabel()
    private let dragImageView = UIImageView(image: UIImage(named: "ic_dragable"))
    
    private let firstShadow = NeverChangingBackgroundView()
    private let secondShadow = NeverChangingBackgroundView()
    
    
    var model: PrivateKeyPart? {
        didSet {
            keyLabel.text = model?.key
            sentenceLabel.text = model?.sentencePart
        }
    }
    
    init(dragable: Bool = false) {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        // Add icon view
        addSubview(iconImageView)
        
        // Add key label
        keyLabel.textColor = .white
        keyLabel.text = "Key"
        addSubview(keyLabel)
        
        // Add sentence label
        sentenceLabel.textColor = .df_green
        sentenceLabel.text = "Sentence"
        addSubview(sentenceLabel)
        
        // Add first shadow view
        firstShadow.backgroundColor = .df_shadowLightBlue
        addSubview(firstShadow)
        
        // Add second shadow view
        secondShadow.backgroundColor = .df_lightBlue
        addSubview(secondShadow)
        
        if dragable {
            // Add dragable icon
            addSubview(dragImageView)
        }
        
        addSubview(firstShadow)
        addSubview(secondShadow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: 4, y: (bounds.height-5)/2 - 12, width: 24, height: 24)
        keyLabel.frame = CGRect(x: 34, y: 10, width: bounds.width-34, height: 19)
        sentenceLabel.frame = CGRect(x: 34, y: 29, width: bounds.width-34, height: 19)
        dragImageView.frame = CGRect(x: bounds.width-29, y: (bounds.height-5)/2 - 12, width: 24, height: 24)
        
        firstShadow.frame = CGRect(x: 0, y: bounds.height-5, width: bounds.width, height: 2)
        secondShadow.frame = CGRect(x: 0, y: bounds.height-3, width: bounds.width, height: 3)
        
        firstShadow.backgroundColor = .df_shadowLightBlue
        secondShadow.backgroundColor = .df_lightBlue
    }
}
