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
            if (isEditable) {
                TextField("?", text: $toDoItem.description)
                    .onChange(of: toDoItem.description) {
                        toDoService.editItemDescription(itemId: toDoItem.id, newDescription: $0.lowercased())
                    }
            } else {
                Text(toDoItem.description.lowercased())
                    .strikethrough(toDoItem.checked)
                    .foregroundColor(toDoItem.checked ? .gray : .primary)
            }
        }
        .onTapGesture {
            if (!isEditable) {
                toDoService.toggleItemChecked(itemId: toDoItem.id)
                toDoItem.checked.toggle()
            }
        }
    }
}
