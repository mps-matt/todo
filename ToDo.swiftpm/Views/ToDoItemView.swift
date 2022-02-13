import SwiftUI

struct ToDoItemView: View {
    @State var toDoItem: ToDoItem 
    @EnvironmentObject private var toDoService: ToDoService
    
    var body: some View {
        HStack {
            Image(systemName: toDoItem.checked ? "checkmark.circle.fill" : "circle")
            Text(toDoItem.description)
                .strikethrough(toDoItem.checked)
                .foregroundColor(toDoItem.checked ? .gray : .primary)
        }
        .onTapGesture {
            toDoService.toggleItemChecked(itemId: toDoItem.id)
            toDoItem.checked.toggle()
        }
    }
}
