import UIKit

/// Base table view cell that every cell should inherit from.
class BaseCell: UITableViewCell {
    
    override required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    public static func cell<Cell: BaseCell>() -> Cell {
        let c = Cell(style: .value1, reuseIdentifier: string(fromClass: Cell.self))
        return c
    }

    /// Entry point for subclasses to participate in UI setup.
    public func setupUI() {}
}

