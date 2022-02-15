import SwiftUI

struct ToDoItemView: View {
    @State var toDoItem: ToDoItem 
    @Binding var isEditable: Bool
    @EnvironmentObject private var toDoService: ToDoService
    
    var body: some View {
        HStack {
            Image(systemName: toDoItem.checked ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    toDoService.toggleItemChecked(itemId: toDoItem.id)
                    toDoItem.checked.toggle()
                }
                .foregroundColor(toDoItem.checked ? .green : .blue)
            if (!isEditable) {
                Text(toDoItem.description.lowercased())
                    .strikethrough(toDoItem.checked)
                    .foregroundColor(toDoItem.checked ? .gray : .primary)
                    .onTapGesture {
                        toDoService.toggleItemChecked(itemId: toDoItem.id)
                        toDoItem.checked.toggle()
                    }
            } else {
                TextField("?", text: $toDoItem.description)
                    .onChange(of: toDoItem.description) {
                        toDoService.editItemDescription(itemId: toDoItem.id, newDescription: $0.lowercased())
                    }
            }
        }
        .onTapGesture {
        }
    }
}
