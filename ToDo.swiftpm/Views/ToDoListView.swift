import SwiftUI

struct ToDoListView: View {
    @State var title: String
    @State var toDoList: [ToDoItem]
    
    @EnvironmentObject private var toDoService: ToDoService
    
    @State private var newToDo = ""
    @State private var isEditable = false
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                TextField("?", text: $newToDo)
                Button("+") {
                    if (!newToDo.trimmingCharacters(in: .whitespaces).isEmpty) {
                        toDoService.add(toDoItem: ToDoItem(description: newToDo))
                        newToDo = ""
                    }
                }
            }
            .padding()
            
            List {
                ForEach(toDoService.toDoList) { toDoItem in 
                    ToDoItemView(toDoItem: toDoItem)
                }
                .onDelete(perform: toDoService.delete)
                .onMove(perform: toDoService.move)
                .onLongPressGesture() {
                    withAnimation {
                        isEditable = !isEditable
                    }
                    
                }
            }
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
        }
        .textFieldStyle(.roundedBorder)
        .buttonStyle(.bordered)
        .navigationBarTitle(title)
        .navigationBarItems(trailing: Button(action: {
            self.isEditable = !self.isEditable
        }) {
            Text(isEditable ? "Done" : "Edit")
        })
        }
    }
}
