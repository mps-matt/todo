import SwiftUI

struct ToDoItemView: View {
    @State var toDoItem: ToDoItem 
    @Binding var isEditable: Bool
    @State var toDoCategory: ToDoCategory
    @FocusState private var isTimeFocused: Bool
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
                Spacer()
                
                if (toDoCategory == ToDoCategory.daily) {
                if (toDoItem.dueTime == nil || toDoItem.checked) {
                    Image(systemName: "clock")
                        .foregroundColor(toDoItem.checked ? .gray : .blue)
                        .onTapGesture {
                            if (!toDoItem.checked) {
                                toDoItem.dueTime = Date().dateOnly
                                toDoService.editItemTime(itemId: toDoItem.id, newTime: toDoItem.dueTime)
                            }
                        }
                } else {
                    DatePicker("", selection: $toDoItem.dueTime, displayedComponents: [ .hourAndMinute])
                        .focused($isTimeFocused)
                        .onChange(of: isTimeFocused) { isTimeFocused in
                            if (!isTimeFocused) {
                                toDoService.editItemTime(itemId: toDoItem.id, newTime: toDoItem.dueTime)
                            }
                        }
                }}
                
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
