import UIKit

class ProfileKeyView: UIView {
    
    private let iconImageView = UIImageView(image: UIImage(named: "ic_key_small"))
    private let locationLabel = BaseLabel()
    private(set) var model: PrivateKeyPart? {
        didSet {
            locationLabel.text = model?.location
        }
    }
    
    init(model: PrivateKeyPart) {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        iconImageView.contentMode = .scaleAspectFill
        addSubview(iconImageView)
        
        locationLabel.text = model.location
        locationLabel.textColor = .df_green
        locationLabel.font = UIFont.df.bold(size: .normal)
        addSubview(locationLabel)
        
        self.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: 4, y: (bounds.height)/2 - 12, width: 24, height: 24)
        locationLabel.frame = CGRect(x: 34, y: 0, width: bounds.width-34, height: 40)
    }
}
