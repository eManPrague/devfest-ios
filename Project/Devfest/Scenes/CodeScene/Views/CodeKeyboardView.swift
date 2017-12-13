import UIKit
import RxSwift

class CodeKeyboardView: UIView {
    
    private let bag = DisposeBag()
    
    // MARK: - Outputs
    
    private let characterOutput = PublishSubject<String>()
    var characterObservable: Observable<String> { return characterOutput.asObservable() }
    
    private let clearOutput = PublishSubject<Void>()
    var clearObservable: Observable<Void> { return clearOutput.asObservable() }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        // Create array of all keyboard buttons
        let buttons = [
            CodeKeyboardButton(type: .a),
            CodeKeyboardButton(type: .b),
            CodeKeyboardButton(type: .c),
            CodeKeyboardButton(type: .d),
            CodeKeyboardButton(type: .e),
            CodeKeyboardButton(type: .f),
            CodeKeyboardButton(type: .g),
            CodeKeyboardButton(type: .h),
            CodeKeyboardButton(type: .i),
            CodeKeyboardButton(type: .j),
            CodeKeyboardButton(type: .one),
            CodeKeyboardButton(type: .two),
            CodeKeyboardButton(type: .three),
            CodeKeyboardButton(type: .four),
            CodeKeyboardButton(type: .five),
            CodeKeyboardButton(type: .six),
            CodeKeyboardButton(type: .seven),
            CodeKeyboardButton(type: .eight),
            CodeKeyboardButton(type: .nine),
            CodeKeyboardButton(type: .zero)
        ]

        // Create four rows of keyboard
        let first = UIStackView(arrangedSubviews: Array(buttons[0..<5]))
        let second = UIStackView(arrangedSubviews: Array(buttons[5..<10]))
        let third = UIStackView(arrangedSubviews: Array(buttons[10..<15]))
        let fourth = UIStackView(arrangedSubviews: Array(buttons[15..<20]))
        
        // Setup every stack view
        for stackView in [first, second, third, fourth] {
            stackView.distribution = .fillEqually
            stackView.spacing = 10
        }
        
        // Create clear button
        let clearButton = UIButton()
        clearButton.setBackgroundImage(UIColor.df_background.em_image, for: .normal)
        clearButton.setBackgroundImage(UIColor.df_background.withAlphaComponent(0.8).em_image, for: .selected)
        clearButton.setBackgroundImage(UIColor.df_background.withAlphaComponent(0.8).em_image, for: .highlighted)
        clearButton.titleLabel?.font = UIFont(name: "Courier", size: 22)
        clearButton.setTitle(locs("key_part_add.button.clear").uppercased(), for: .normal)
        clearButton.rx.tap.bind(to: clearOutput).disposed(by: bag)
        CodeActivationManager.shared.enableObservable.bind(to: clearButton.rx.isUserInteractionEnabled).disposed(by: bag)
        CodeActivationManager.shared.enableObservable.map { enabled in
            enabled ? UIColor.white : UIColor(white: 1, alpha: 0.3)
        }.bind { clearButton.setTitleColor($0, for: .normal) }.disposed(by: bag)
        
        // Create root stack view
        let rootStackView = UIStackView.vertical.space(by: 10).stack(
            first,
            second,
            third,
            fourth,
            clearButton
        )
        
        // Add root stack view
        addSubview(rootStackView)
        rootStackView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) }
        
        // Setup clear button
        clearButton.snp.makeConstraints { $0.height.equalTo(60) }
        
        // Bind and setup output from every button in keyboard
        for button in buttons {
            button.snp.makeConstraints { $0.height.equalTo(60) }
            button.characterObservable.bind(to: characterOutput).disposed(by: bag)
            CodeActivationManager.shared.enableObservable.bind(to: button.rx.isEnabled).disposed(by: bag)
            CodeActivationManager.shared.enableObservable.map { enabled in
                enabled ? UIColor.white : UIColor(white: 1, alpha: 0.3)
            }.bind { button.setTitleColor($0, for: .normal) }.disposed(by: bag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
