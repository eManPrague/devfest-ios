import UIKit
import Firebase

/// The game progress
class GameProgress: BaseDataObject {

    // Progress entries per every user. [ userID: [progressEnty] ]
    let entries: [String: [GameProgressEntry]]
    
    override init(snapshot: DataSnapshot) {
        var entries: [String: [GameProgressEntry]] = [:]
        snapshot.children.forEach {
            let s = $0 as! DataSnapshot
            let gameProgressEntry = s.children.map({ GameProgressEntry(snapshot: $0 as! DataSnapshot, userID: s.key) })
            var filteredProgressEntry = [GameProgressEntry]()
            
            for progress in gameProgressEntry {
                guard !filteredProgressEntry.contains(progress) else { return }
                filteredProgressEntry.append(progress)
            }
            
            entries[s.key] = filteredProgressEntry
        }

        self.entries = entries
        super.init(snapshot: snapshot)
    }
    
    func entries(forUser: String) -> [GameProgressEntry] {
        return entries[forUser] ?? []
    }
    
}

extension GameProgress: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String { return "GameProgress: entries = \(entries)" }
    var description: String { return debugDescription }
}
