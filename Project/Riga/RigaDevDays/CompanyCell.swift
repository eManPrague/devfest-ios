import UIKit

class CompanyCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .rddDefaultColor
        clipsToBounds = false
        
        // Make logo view
        let logoView = UIImageView(image: #imageLiteral(resourceName: "img_eman_logo_white"))
        
        // Make title label
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "Game developed by eMan"
        
        let rootStackView = UIStackView.vertical.align(by: .center).space(by: 15).stack(logoView, titleLabel)
        contentView.addSubview(rootStackView)
        rootStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let fakeBackground = UIView()
        fakeBackground.backgroundColor = .rddDefaultColor
        contentView.addSubview(fakeBackground)
        fakeBackground.snp.makeConstraints { (make) in
            make.size.equalTo(UIScreen.main.bounds.size)
            make.bottom.equalTo(snp.top)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
