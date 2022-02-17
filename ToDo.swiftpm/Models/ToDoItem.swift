import SwiftUI

enum ToDoCategory: Encodable, Decodable {
    case daily, monthly, yearly, infinity, none
}

struct ToDoItem: Identifiable, Encodable, Decodable {
    var id: UUID = UUID()
    var description: String = ""
    var checked = false
    var category: ToDoCategory
    var dueTime: Date!
    var notificationSet: Bool! = false
    var notificationUUID: String! = "" 
    var repeatsOn: [Int]! = []
}
