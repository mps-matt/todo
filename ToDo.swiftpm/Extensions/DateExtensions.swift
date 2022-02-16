import SwiftUI

extension Date {
    public var dateOnly : Date? {
        guard let dateWithoutTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return dateWithoutTime
    }
    
    static func hour(date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: date)
    }
    
    static func minute(date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: date)
    }
}
