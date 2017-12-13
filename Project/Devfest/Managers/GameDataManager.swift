import UIKit
import Firebase
import RxSwift
import RxOptional

import FirebaseAuth
import FirebaseAuthUI
//import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI

/// Game data manager.
class GameDataManager /*: DataManager*/ {

    // MARK: Static
    
    static let shared = GameDataManager()
    
    // MARK: Public
    
    private(set) var privateKey: PrivateKey? { didSet { privateKeyVariable.value = privateKey } }
    private(set) var privateKeyParts: [PrivateKeyPart] = [] { didSet { privateKeyPartsVariable.value = privateKeyParts } }
    private(set) var gameProgress: GameProgress? { didSet { gameProgressVariable.value = gameProgress } }
    private(set) var users: [User] = [] { didSet { usersVariable.value = users } }
    private(set) var currentUser: User? { didSet { currentUserVariable.value = currentUser } }
    private(set) var isConnected: Bool = false
    
    // Computed
    
    var userToBeSaved: Firebase.User?
    var totalNumberOfKeys: Int { return privateKeyParts.count }
    
    // MARK: Private
    
    private var dbRef: DatabaseReference { return Database.database().reference() }
    private let bag = DisposeBag()
    
    // MARK: Private - RxSupport
    
    private var privateKeyVariable = Variable<PrivateKey?>(nil)
    var privateKeyObservable: Observable<PrivateKey?> { return privateKeyVariable.asObservable() }
    
    private var privateKeyPartsVariable = Variable<[PrivateKeyPart]>([])
    var privateKeyPartsObservable: Observable<[PrivateKeyPart]> { return privateKeyPartsVariable.asObservable() }
    
    private var gameProgressVariable = Variable<GameProgress?>(nil)
    var gameProgressObservable: Observable<GameProgress?> { return gameProgressVariable.asObservable() }
    
    private var usersVariable = Variable<[User]>([])
    var usersObservable: Observable<[User]> { return rx_gameUpdateObservable.map { $0.1 } }
    
    private var currentUserVariable = Variable<User?>(nil)
    var currentUserObservable: Observable<User> { return rx_gameUpdateObservable.map({ $0.0 }).filter({ $0 != nil }).map({ $0! }) }
    
    var rx_gameUpdateObservable: Observable<(User?, [User], GameProgress?)> {
        return Observable.combineLatest(
            currentUserVariable.asObservable(),
            usersVariable.asObservable(),
            gameProgressVariable.asObservable()
        )
    }
    
    // MARK: Lifecycle
    
    init() {
        Observable.combineLatest(
            Notification.Name.UserDidSignIn.asObservable(),
            Notification.Name.usersUpdated.asObservable())
        .bind { [weak self] sender, _ in
            guard let user = Auth.auth().currentUser else { return }
            
            if let savedUser = self?.users.filter({ $0.key == Auth.auth().currentUser?.uid }).first {
                self?.currentUser = savedUser
            } else {
                guard self?.currentUser == nil else { return }
                self?.saveUserIfNeded(user)
            }
        }.disposed(by: bag)
        
        Notification.Name.UserDidSignOut.bind { [weak self] sender in
            self?.currentUser = nil
        }.disposed(by: bag)
    }
    
    // MARK: Private funcs
    
    // MARK: Public funcs
    
    func startObservingGameData() {
        // Private key
        dbRef.child("cdhPrivateKey").observe(.value, with: { [weak self] snapshot in
            self?.privateKey = PrivateKey(snapshot: snapshot)
            NotificationCenter.default.post(name: .privateKeyUpdated, object: nil)
        })
        // Private key parts
        dbRef.child("cdhPrivateKeyParts").observe(.value, with: { [weak self] snapshot in
            self?.privateKeyParts = snapshot.children.map({ PrivateKeyPart(snapshot: $0 as! DataSnapshot) })
            NotificationCenter.default.post(name: .privateKeyPartsUpdated, object: nil)
        })
        // Game progress
        dbRef.child("cdhProgress").observe(.value, with: { [weak self] snapshot in
            self?.gameProgress = GameProgress(snapshot: snapshot)
            NotificationCenter.default.post(name: .gameProgressUpdated, object: nil)
        })
        // Users
        dbRef.child("users").queryOrdered(byChild: "cdhScore").observe(.value, with: { [weak self] snapshot in
            let userModels = snapshot.children.map{ User(snapshot: $0 as! DataSnapshot) }
            self?.users = userModels.reversed()
            if let user = self?.userToBeSaved {
                self?.saveUserIfNeded(user)
            }
            
            Log.info("Game: Users fetched (\(self!.users.count)): \(self!.users.map{ $0.email })")
            NotificationCenter.default.post(name: .usersUpdated, object: nil)
        })
        // Observe connection state
        dbRef.child(".info/connected").observe(.value, with: { [weak self] snapshot in
            self?.isConnected = snapshot.value as? Bool ?? false
        })
    }
    
    func saveUserIfNeded(_ user: Firebase.User) {
        // Check for existing user
        Log.info("Game: Saving new user. Users fetched (\(users.count)): \(users.map{ $0.email })")
        if users.first(where: { $0.key == user.uid }) == nil {
            
            if user.email == nil {
                try? FUIAuth.defaultAuthUI()?.signOut()
                alert()
            } else {
                // Save new user
                let value = ["cdhScore": 0,
                             "correctOrderServerTimestamp": 0,
                             "email": user.email ?? "",
                             "name": user.displayName ?? user.email?.components(separatedBy: "@").first ?? "",
                             "photoUrl": user.photoURL?.absoluteString ?? "null"] as [String : Any]
                let ref = dbRef
                ref.child("users/\(user.uid)").updateChildValues(value) { _,_ in
                    // Create a new entry in cdhProgress
                    ref.child("cdhProgress/\(user.uid)").setValue("dummyProgress")
                }
                userToBeSaved = nil
            }
        } else if Auth.auth().currentUser?.uid == currentUser?.key {
            
            if user.email == nil {
                try? FUIAuth.defaultAuthUI()?.signOut()
                alert()
            } else {
                // Notify
                currentUserVariable.value = currentUser
            }
        } else {
            NotificationCenter.default.post(name: .usersUpdated, object: nil)
        }
    }
    
    private func alert() {
        let alertController = UIAlertController(title: locs("login.alert.invalid.title"), message: locs("login.alert.invalid.message"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func saveIfNeeded(keyPartID: String, forUser: User, completion: (() -> ())?) {
        Log.info("Game: Saving new progress entry \(keyPartID) for user \(forUser.email)")
        if (progressEntries(forUserID: forUser.key).contains(where: { $0.keyID == keyPartID})) {
            // Already done -> do nothing
            completion?()
        } else {
            // Save the given key part
            let value = ["privateKeyPart": keyPartID,
                         "serverTimestamp": Date().timeIntervalSince1970] as [String : Any]
            let newProgressEntry = dbRef.child("cdhProgress/\(forUser.key)").childByAutoId()
            newProgressEntry.updateChildValues(value) { _, _ in
                completion?()
            }
        }
    }
    
    func update(progressEntries: [GameProgressEntry], forUserID: String, completion: (() -> ())?) {
        Log.info("Game: Updating progress entries: \(progressEntries) for user: \(forUserID)")
        var values: [String: Any] = [:]
        progressEntries.forEach {
            values[$0.key] = ["privateKeyPart": $0.keyID,
                              "serverTimestamp": $0.timestamp]
        }
        dbRef.child("cdhProgress/\(forUserID)").setValue(values) { _, _ in
            completion?()
        }
    }
    
    func markSentenceCompleted(forUserID: String, completion: (() -> ())?) {
        Log.info("Game: Marking sentence completed for user \(forUserID)")
        dbRef.child("users/\(forUserID)/correctOrderServerTimestamp").setValue(ServerValue.timestamp()) { _, _ in
            completion?()
        }
    }
    
    func progressEntries(forUserID: String) -> [GameProgressEntry] {
        return gameProgress?.entries(forUser: forUserID) ?? []
    }
    
    func hasAllKeysDone(userID: String) -> Bool {
        return progressEntries(forUserID: userID).count == privateKeyParts.count
    }
    
    func position(of: User) -> Int {
        let index = (users as NSArray).index(of: of)
        return index == NSNotFound ? users.count + 2 : index + 1
    }
    
    func remainingKeyParts(forUserID: String) -> [PrivateKeyPart] {
        let donePartsIDs = progressEntries(forUserID: forUserID).map({ $0.keyID })
        return privateKeyParts.filter({ !donePartsIDs.contains($0.key) })
    }
    
    func isCorrect(sentence: String) -> Bool {
        return privateKey != nil && privateKey!.sequence == sentence
    }
}


