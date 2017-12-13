import UIKit
import Firebase

/// Single progress entry
class GameProgressEntry: BaseDataObject {

    let keyID: String
    let timestamp: NSNumber
    /// Convenience
    private(set) var userID: String? = nil
    
    override init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String: AnyObject] ?? [:]
        keyID = value["privateKeyPart"] as? String ?? ""
        timestamp = value["serverTimestamp"] as? NSNumber ?? NSNumber(integerLiteral: 0)
        super.init(snapshot: snapshot)
    }
    
    convenience init(snapshot: DataSnapshot, userID: String) {
        self.init(snapshot: snapshot)
        self.userID = userID
    }
}

extension GameProgressEntry: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String { return "GameProgressEntry: ID = \(key), keyID = \(keyID), timestamp = \(timestamp), userID = \(userID ?? "'-unknown-'")" }
    var description: String { return debugDescription }
}
