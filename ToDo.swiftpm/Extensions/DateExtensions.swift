import SwiftUI

extension Date {
    public var dateOnly : Date? {
        guard let dateWithoutTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return dateWithoutTime
    }
}
