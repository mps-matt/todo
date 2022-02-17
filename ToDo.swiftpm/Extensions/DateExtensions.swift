import SwiftUI

extension Date {
    public var dateOnly : Date? {
        guard let dateWithoutTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return dateWithoutTime
    }
    
    static func getFirstLetterOf(dayOfWeek: Int) -> String {
        switch (dayOfWeek) {
        case 1: 
            return getFirstLetterOfMonday()
        case 2:
            return getFirstLetterOfTuesday()
        case 3:
            return getFirstLetterOfWednesday()
        case 4:
            return getFirstLetterOfThursday()
        case 5:
            return getFirstLetterOfFriday()
        case 6:
            return getFirstLetterOfSaturday()
        case 7:
            return getFirstLetterOfSunday()
        default:
            return ""
        }
    }
    
    static func getFirstLetterOfMonday() -> String {
        let date = convertDateStringToDate(strDate: "2022/02/14 00:00") ?? Date()
        return getFirstLetterOfDay(date: date)
    }
    
    static func getFirstLetterOfTuesday() -> String {
        let date = convertDateStringToDate(strDate: "2022/02/15 00:00") ?? Date()
        return getFirstLetterOfDay(date: date)
    }
    
    static func getFirstLetterOfWednesday() -> String {
        let date = convertDateStringToDate(strDate: "2022/02/16 00:00") ?? Date()
        return getFirstLetterOfDay(date: date)
    }
    
    static func getFirstLetterOfThursday() -> String {
        let date = convertDateStringToDate(strDate: "2022/02/17 00:00") ?? Date()
        return getFirstLetterOfDay(date: date)
    }
    
    static func getFirstLetterOfFriday() -> String {
        let date = convertDateStringToDate(strDate: "2022/02/18 00:00") ?? Date()
        return getFirstLetterOfDay(date: date)
    }
    
    static func getFirstLetterOfSaturday() -> String {
        let date = convertDateStringToDate(strDate: "2022/02/19 00:00") ?? Date()
        return getFirstLetterOfDay(date: date)
    }
    
    static func getFirstLetterOfSunday() -> String {
        let date = convertDateStringToDate(strDate: "2022/02/20 00:00") ?? Date()
        return getFirstLetterOfDay(date: date)
    }
    
    static func convertDateStringToDate(strDate: String) -> Date! {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: strDate)
    }
    
    static func getFirstLetterOfDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return (dateFormatter.string(from: date).prefix(1).lowercased())
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
