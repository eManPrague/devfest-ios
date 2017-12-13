import Firebase

class BaseDataObject: DataObject {
    
}

extension BaseDataObject: Equatable {

}

func ==<T: BaseDataObject>(lhs: T, rhs: T) -> Bool {
    return "\(String(describing: lhs)) \(lhs.key)" == "\(String(describing: rhs)) \(rhs.key))"
}

protocol DataObjectRepresentable {
    var dictionaryRepresentable: [String: AnyObject] { get }
}
