import UIKit
import RxSwift

class ProfileCodeView: UIView {
    
    private let bag = DisposeBag()
    
    // MARK: - Input
    
    private let privateKeyInput = ReplaySubject<PrivateKey?>.create(bufferSize: 1)
    var privateKeyObserver: AnyObserver<PrivateKey?> { return privateKeyInput.asObserver() }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        let titleLabel = BaseLabel()
        titleLabel.text = "\(locs("profile.text.deactivation_code.title"))"
        titleLabel.textColor = .white
        
        let codeLabel = BaseLabel()
        privateKeyInput.map{ $0?.sequence }.bind(to: codeLabel.rx.text).disposed(by: bag)
        codeLabel.textColor = .df_green
        codeLabel.adjustsFontSizeToFitWidth = true
        
        let rootStackView = UIStackView.vertical.space(by: 10).inset(by: UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)).stack(titleLabel, codeLabel)
        addSubview(rootStackView)
        rootStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
