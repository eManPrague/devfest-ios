import UIKit
import RxSwift

class CodeKeyboardButton: UIButton {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let characterOutput = PublishSubject<String>()
    var characterObservable: Observable<String> { return characterOutput.asObservable() }

    enum ButtonType: String {
        case a = "a"
        case b = "b"
        case c = "c"
        case d = "d"
        case e = "e"
        case f = "f"
        case g = "g"
        case h = "h"
        case i = "i"
        case j = "j"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case zero = "0"
    }

    init(type: ButtonType) {
        super.init(frame: .zero)
        
        backgroundColor = .df_background
        
        setTitle(type.rawValue.uppercased(), for: .normal)
        titleLabel?.font = UIFont.df.regular(size: .huge)
        
        rx.tap.map { type.rawValue.uppercased() }.bind(to: characterOutput).disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = UIColor.df_background.withAlphaComponent(0.8)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = .df_background
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = .df_background
    }
}
