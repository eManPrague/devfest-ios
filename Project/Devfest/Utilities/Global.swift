import Foundation

// MARK: Functions

public func string<T>(fromClass: T) -> String {
    return String(describing: fromClass).components(separatedBy: ".").last ?? "'Unknown class'"
}

/// Wrap all localization keys with this function.
///
/// - parameter key: Use keys with namespaces like "some-namespace.some.key"
public func locs(_ key: String) -> String {
    return NSLocalizedString(key, comment: key)
}
