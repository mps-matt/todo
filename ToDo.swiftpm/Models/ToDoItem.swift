import SwiftUI

struct ToDoItem: Identifiable, Encodable, Decodable {
    var id: UUID = UUID()
    var description: String = ""
    var checked = false
}
