import UIKit
import Firebase

// Private key part with ID, location and a part of the final sentence.
class PrivateKeyPart: BaseDataObject {

    /// Sentence part/word(s) - 'Welcome'
    let sentencePart: String
    /// Location - 'Pod stánkem eMan'
    let location: String
    
    override init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        sentencePart = snapshotValue["controlWord"] as! String
        location = snapshotValue["location"] as! String
        super.init(snapshot: snapshot)
    }
    
}

extension PrivateKeyPart: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String { return "PrivateKeyPart: ID = \(key), sentencePart = \(sentencePart), location = \(location)" }
    var description: String { return debugDescription }
}
