import SwiftUI

struct ToDoItemView: View {
    @State var toDoItem: ToDoItem 
    @Binding var isEditable: Bool
    @State var toDoCategory: ToDoCategory
    @EnvironmentObject private var toDoService: ToDoService
    
    private var dueTimeProxy: Binding<Date> {
        Binding<Date>(get: {toDoItem.dueTime }, set: {
            toDoItem.dueTime = $0
            toDoItem.notificationSet = true
            toDoService.editItemTime(itemId: toDoItem.id, newTime: toDoItem.dueTime)
        })
    }
    
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
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                
                if (toDoCategory == ToDoCategory.daily && !toDoItem.checked) {
                if (toDoItem.dueTime == nil || !(toDoItem.notificationSet ?? false)) {
                    Image(systemName: "clock")
                        .foregroundColor(toDoItem.checked ? .gray : .blue)
                        .onTapGesture {
                            if (!toDoItem.checked) {
                                toDoItem.dueTime = Date().dateOnly
                                toDoItem.notificationSet = true
                                toDoService.editItemTime(itemId: toDoItem.id, newTime: toDoItem.dueTime)
                            }
                        }
                } else {
                    DatePicker("", selection: dueTimeProxy, displayedComponents: [ .hourAndMinute])
                        .onTapGesture {}
                        .onLongPressGesture(perform: {
                            toDoItem.notificationSet = false
                            toDoService.unsetNotification(itemId: toDoItem.id)
                        })
                }}
            } else {
                TextField("?", text: $toDoItem.description)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: toDoItem.description) {
                        toDoService.editItemDescription(itemId: toDoItem.id, newDescription: $0.lowercased())
                    }
            }
        }
        .onTapGesture {
        }
    }
}
