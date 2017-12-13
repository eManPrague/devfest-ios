import UIKit
import SDWebImage

class ProfileView: UIView {
    
    private let userImageView = UIImageView()
    private let userNameLabel = BaseLabel()
    private let userPositionLabel = BaseLabel()
    private let userPointsLabel = BaseLabel()
    
    var viewModel: UserViewModel? {
        didSet {
            userImageView.sd_setImage(with: viewModel?.photoURL, placeholderImage: nil)
            userNameLabel.text = viewModel?.name
            userPositionLabel.text = viewModel?.position
            userPointsLabel.attributedText = viewModel?.numberOfPointsString
        }
    }

    init() {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 1
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        addSubview(userImageView)

        userNameLabel.textColor = .white
        userNameLabel.text = "Name label"
        userNameLabel.font = UIFont.df.bold(size: .normal)
        addSubview(userNameLabel)

        userPositionLabel.textColor = .df_green
        userPositionLabel.text = "Position label"
        addSubview(userPositionLabel)
        
        userPointsLabel.textColor = .df_green
        userPointsLabel.text = "Points label"
        addSubview(userPointsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame = CGRect(x: 15, y: 15, width: 60, height: 60)
        userNameLabel.frame = CGRect(x: 90, y: 12, width: bounds.width-90, height: 22)
        userPositionLabel.frame = CGRect(x: 90, y: 34, width: bounds.width-90, height: 19)
        userPointsLabel.frame = CGRect(x: 90, y: 59, width: bounds.width-90, height: 19)
    }
}
