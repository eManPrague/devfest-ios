import UIKit

extension UITableView {
	
    // Register UITableViewCell without .xib file
    public func em_register<T:UITableViewCell>(_ cell: T.Type) {
        register(cell, forCellReuseIdentifier: T.em_reuseIdentifier)
    }
    
    // Register UITableViewCell with associated .xib file
	public func em_registerNib<T:UITableViewCell>(_ cell: T.Type) {
		register(T.em_nib, forCellReuseIdentifier: T.em_reuseIdentifier)
	}
    
    // Register UITableViewHeaderFooterView without .xib file
    public func em_registerHeaderFooter<T:UITableViewHeaderFooterView>(_ view: T.Type) {
        register(view, forHeaderFooterViewReuseIdentifier: T.em_reuseIdentifier)
    }
    
    // Register UITableViewHeaderFooterView with associated .xib file
    public func em_registerHeaderFooterNib<T:UITableViewHeaderFooterView>(_ view: T.Type) {
        register(T.em_nib, forHeaderFooterViewReuseIdentifier: T.em_reuseIdentifier)
    }
    
    // Dequeue UITableViewCell
    public func em_dequeue<T:UITableViewCell>(_ cell: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.em_reuseIdentifier) as! T
    }
    
    // Dequeue UITableViewCell on cellForRowAt indexPath
	public func em_dequeue<T:UITableViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
		return dequeueReusableCell(withIdentifier: T.em_reuseIdentifier, for: indexPath) as! T
	}
    
    // Dequeue UITableViewHeaderFooterView for header and footer
    public func em_dequeueHeaderFooter<T:UITableViewHeaderFooterView>(_ view: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.em_reuseIdentifier) as! T
    }
}
