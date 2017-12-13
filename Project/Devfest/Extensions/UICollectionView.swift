import UIKit

extension UICollectionView {
    
    // Register UICollectionViewCell without .xib file
    public func em_register<T:UICollectionViewCell>(_ cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: T.em_reuseIdentifier)
    }
    
    // Register UICollectionViewCell with associated .xib file
	public func em_registerNib<T:UICollectionViewCell>(_ cell: T.Type) {
		register(T.em_nib, forCellWithReuseIdentifier: T.em_reuseIdentifier)
	}
	
    // Register UICollectionReusableView as header of section without .xib file
    public func em_registerHeader<T:UICollectionReusableView>(_ view: T.Type) {
        register(view, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.em_reuseIdentifier)
    }
    
    // Register UICollectionReusableView as header of section with associated .xib file
	public func em_registerHeaderNib<T:UICollectionReusableView>(_ view: T.Type) {
		register(T.em_nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.em_reuseIdentifier)
	}
    
    // Register UICollectionReusableView as footer of section without .xib file
    public func em_registerFooter<T:UICollectionReusableView>(_ view: T.Type) {
        register(view, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.em_reuseIdentifier)
    }
	
    // Register UICollectionReusableView as footer of section with associated .xib file
	public func em_registerFooterNib<T:UICollectionReusableView>(_ view: T.Type) {
		register(T.em_nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.em_reuseIdentifier)
	}
    
    // Dequeue UICollectionViewCell on cellForItemAt indexPath
	public func em_dequeue<T:UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
		return dequeueReusableCell(withReuseIdentifier: T.em_reuseIdentifier, for: indexPath) as! T
	}
	
    // Dequeue UICollectionReusableView as header on cellForItemAt indexPath
	public func em_dequeueHeader<T:UICollectionReusableView>(_ view: T.Type, indexPath: IndexPath) -> T {
		return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.em_reuseIdentifier, for: indexPath) as! T
	}
	
    // Dequeue UICollectionReusableView as footer on cellForItemAt indexPath
	public func em_dequeueFooter<T:UICollectionReusableView>(_ view: T.Type, indexPath: IndexPath) -> T {
		return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.em_reuseIdentifier, for: indexPath) as! T
	}
}
