import UIKit
import Foundation

extension UIFont {
    struct df {
//        static func light(size: FontSize) -> UIFont {
//            return UIFont.systemFont(ofSize: size, weight: UIFontWeightLight)
//        }
        static func regular(size: FontSize) -> UIFont {
            return UIFont(name: "Courier", size: size)!
        }
//        static func medium(size: FontSize) -> UIFont {
//            return UIFont.systemFont(ofSize: size, weight: UIFontWeightMedium)
//        }
        static func bold(size: FontSize) -> UIFont {
            return UIFont(name: "Courier-Bold", size: size)!
        }
    }
}

typealias FontSize = CGFloat

extension FontSize {
    static let small = CGFloat(17)
    static let normal = CGFloat(19)
    static let large = CGFloat(23)
    static let huge = CGFloat(35)
    static let enormous = CGFloat(50)
}
