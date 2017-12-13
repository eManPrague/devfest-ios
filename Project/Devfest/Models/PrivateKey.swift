import UIKit
import Firebase

/// The private key for the game.
class PrivateKey: BaseDataObject {

    /// The correct sequence of key parts' ids - 'ADD8A9'.
    let sequence: String
    
    
    override init(snapshot: DataSnapshot) {
        sequence = snapshot.value as? String ?? ""
        super.init(snapshot: snapshot)
    }
}

extension PrivateKey: CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String { return "PrivateKey: sequence = \(sequence)" }
    public var description: String { return debugDescription }
}
