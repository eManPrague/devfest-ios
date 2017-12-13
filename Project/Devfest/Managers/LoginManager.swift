import Foundation
import RxSwift
import GoogleSignIn
import FacebookLogin
import FirebaseAuth
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

class LoginManager: NSObject {
    // MARK: Public
    static let shared = LoginManager()
    static var isUserLogged: Bool { return Auth.auth().currentUser != nil }
    
    // Hold user disposable since user can sign in from Riga and we don't wanna show Game scene in that case
    // The scenario is as follows:
    // 1) User initiates login via game button -> (start:) method gets called and we're subscribed
    // 2) User dismisses the login vc without signing in -> but we're still subscribed
    // 3) User initiates login via 'Sign in' button from Riga scene and after finishing signing in the Game scene is shown
    // -> This is unwanted scenario, when users sign in from Riga scene they shoul stay in Riga scene
    static var userDisposable: Disposable? = nil
    
    // MARK: Private
    fileprivate let bag = DisposeBag()
    static private var unknownError: Error { return "'Unknown error'" }
    
    // MARK: Inputs
    
    // MARK: Outputs
    
    // MARK: Lifecycle
    
    fileprivate override init() {
        super.init()
        // Setup FirebaseUI login providers
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        FUIAuth.defaultAuthUI()?.providers = providers
        FUIAuth.defaultAuthUI()?.isSignInWithEmailHidden = true
    }
    
    // MARK: Public funcs
    
    func afterLogout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserDefaultsKeys.loggedInOnce.rawValue)
        NotificationCenter.default.post(name: .UserDidSignOut, object: nil)
    }
    
    func afterLogin() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: UserDefaultsKeys.loggedInOnce.rawValue)
        defaults.synchronize()
    }
    
    func presentLogin(fromVC: UIViewController) {
        LoginManager.userDisposable?.dispose()
        fromVC.present(FUIAuth.defaultAuthUI()!.authViewController(), animated: true, completion: nil)
    }
}
