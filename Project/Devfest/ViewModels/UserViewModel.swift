import Foundation
import UIKit

struct UserViewModel {
    
    // MARK: Public
    
    var id: String { return model.key }
    
    // Info
    var photoURL: URL? { return URL(string: model.photoURLString) }
    var name: String { return model.name }
    var position: String { return "#\(dataManager.position(of: model))" }
    var numberOfPointsString: NSAttributedString {
        let mutableStr = NSMutableAttributedString(string: "\(model.score)", attributes: [NSFontAttributeName: UIFont.df.bold(size: .normal),
                                                                                          NSForegroundColorAttributeName: UIColor.df_green])
        let text = NSAttributedString(string: " \(locs("user.text.points"))", attributes: [NSFontAttributeName: UIFont.df.regular(size: .normal),
                                                                                           NSForegroundColorAttributeName: UIColor.df_green])
        mutableStr.append(text)
        return mutableStr
    }
    // Keys
    var numberOfKeysDone: Int { return dataManager.progressEntries(forUserID: model.key).count }
    var hasAllKeysDone: Bool { return dataManager.hasAllKeysDone(userID: model.key) }
    var keysDoneString: String { return "\(locs("profile.text.keys")) \(numberOfKeysDone)/\(dataManager.totalNumberOfKeys)" }
    // Sentence
    /// Everything that's != 0 is relevant.
    var solvedTimestamp: NSNumber { return model.privateKeySolvedTimestamp }
    var currentSentence: String { return dataManager.progressEntries(forUserID: model.key).map({ $0.keyID }).joined(separator: "") }
    var isSentenceCorrect: Bool { return dataManager.isCorrect(sentence: currentSentence) }
    
    // MARK: Private
    private let model: User
    private var dataManager: GameDataManager { return GameDataManager.shared }
    
    
    init(model: User) {
        self.model = model
    }
}
