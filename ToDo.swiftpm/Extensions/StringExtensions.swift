import SwiftUI

extension StringProtocol {
    var firstLetterUppercased: String { prefix(1).uppercased() + dropFirst().lowercased() }
}
