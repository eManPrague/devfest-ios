import UIKit
import RxSwift

class KeyPartView: UIView {
    
    private let bag = DisposeBag()
    
    // MARK: - Inputs
    
    private let keyPartInput = PublishSubject<String>()
    var keyPartObserver: AnyObserver<String> { return keyPartInput.asObserver() }
    
    init() {
        super.init(frame: .zero)
        
        // Make labels as two character
        let firstCharacter = BaseLabel()
        let secondCharacter = BaseLabel()
        [firstCharacter, secondCharacter].forEach {
            $0.font = UIFont.df.regular(size: .enormous)
            $0.textColor = .white
        }
        
        // Make and add root stack view
        let rootStackView = UIStackView.horizontal.space(by: 20).stack(firstCharacter, secondCharacter)
        addSubview(rootStackView)
        rootStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // Setup labels
        let labels = [firstCharacter, secondCharacter]
        for (index, label) in labels.enumerated() {
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = index == 0 ? .df_green : UIColor.df_green.withAlphaComponent(0.7)
            label.snp.makeConstraints { $0.size.equalTo(CGSize(width: 60, height: 80)) }
        }
        
        keyPartInput.bind {
            print($0)
        }.disposed(by: bag)
        
        // Bind change of key part and visualize to the UI
        keyPartInput.map { $0.characters }.bind { characters in
            if characters.isEmpty {
                for (index, label) in labels.enumerated() {
                    label.backgroundColor = index == 0 ? .df_green : UIColor.df_green.withAlphaComponent(0.7)
                    label.text = nil
                }
            } else {
                for (index, character) in characters.enumerated() {
                    labels[index].text = String(character)
                    labels[index].backgroundColor = UIColor.df_green.withAlphaComponent(0.7)
                    
                    if index+1 < labels.count {
                        labels[index+1].backgroundColor = .df_green
                    }
                }
            }
        }.disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
