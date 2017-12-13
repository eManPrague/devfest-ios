import UIKit
import RxSwift
import RxCocoa

class BaseButton: UIButton {
    
    private let bag = DisposeBag()
    
    private let didtapOutput = PublishSubject<Void>()
    var didTapObservable: Observable<Void> { return didtapOutput.asObservable() }
    
    init(title: String) {
        super.init(frame: .zero)

        setTitle(title.uppercased(), for: .normal)
        setTitleColor(.df_yellow, for: .normal)
        titleLabel?.font = UIFont.df.bold(size: .normal)
        
        rx.tap.bind(to: didtapOutput).disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let first = UIBezierPath()
        first.lineWidth = 2
        first.move(to: CGPoint(x: rect.width-16, y: 0))
        first.addLine(to: CGPoint(x: 0, y: 0))
        first.addLine(to: CGPoint(x: 0, y: rect.height))
        first.addLine(to: CGPoint(x: 16, y: rect.height))
        
        //If you want to stroke it with a red color
        UIColor.df_lightBlue.set()
        first.stroke()
        
        let second = UIBezierPath()
        second.lineWidth = 2
        second.move(to: CGPoint(x: 16, y: rect.height))
        second.addLine(to: CGPoint(x: rect.width, y: rect.height))
        second.addLine(to: CGPoint(x: rect.width, y: 0))
        second.addLine(to: CGPoint(x: rect.width-16, y: 0))
        
        UIColor.black.set()
        second.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = .clear
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = .clear
    }
}
