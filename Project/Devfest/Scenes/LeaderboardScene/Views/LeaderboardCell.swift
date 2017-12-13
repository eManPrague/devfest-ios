import UIKit

class LeaderboardCell: UITableViewCell {
    
    private let profileView = ProfileView()
    
    var viewModel: UserViewModel? {
        didSet {
            profileView.viewModel = viewModel
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(profileView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileView.frame = CGRect(x: 15, y: 0, width: bounds.width-30, height: 90)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
    }
}
