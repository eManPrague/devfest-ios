import UIKit
import Firebase

/// User
class User: BaseDataObject {
    
    var score: NSNumber // This gets calculated localy 
    private(set) var privateKeySolvedTimestamp: NSNumber
    private(set) var name: String
    private(set) var email: String
    private(set) var photoURLString: String

    override init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String: AnyObject] ?? [:]
        score = value["cdhScore"] as? NSNumber ?? NSNumber(integerLiteral: 0)
        privateKeySolvedTimestamp = value["correctOrderServerTimestamp"] as? NSNumber ?? NSNumber(integerLiteral: 0)
        name = value["name"] as? String ?? "-unknown-"
        email = value["email"] as? String ?? "xxx@xxx.xxx"
        photoURLString = value["photoUrl"] as? String ?? ""
        super.init(snapshot: snapshot)
    }
}

extension User: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String { return "User: ID = \(key), score = \(score), privateKeySolvedTimestamp = \(privateKeySolvedTimestamp), name = \(name), email = \(email), photoURLString = \(photoURLString)" }
    var description: String { return debugDescription }
}

extension User: DataObjectRepresentable {
    var dictionaryRepresentable: [String : AnyObject] {
        return ["cdhScore": score,
                "correctOrderServerTimestamp": privateKeySolvedTimestamp,
                "email": email as AnyObject,
                "name": name as AnyObject,
                "photoUrl": photoURLString as AnyObject
        ]
    }
}
