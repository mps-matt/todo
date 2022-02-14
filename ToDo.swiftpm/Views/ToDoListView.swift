import SwiftUI

struct ToDoListView: View {
    @Binding var title: String
    @State var toDoList: [ToDoItem]
    
    @EnvironmentObject private var toDoService: ToDoService
    
    @State private var newToDo = ""
    @State private var isEditable = false
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                TextField("?", text: $newToDo, onCommit: addItem)
                Button("+", action: addItem)
            }
            .padding()
            
            List {
                ForEach(toDoList) { toDoItem in 
                    ToDoItemView(toDoItem: toDoItem)
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
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
        .listStyle(.automatic)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(trailing: Button(action: {
            self.isEditable = !self.isEditable
        }) {
            Image(systemName: isEditable ? "checkmark.circle" : "square.and.pencil")
        })
        }
    }
    
    func addItem() {
        if (!newToDo.trimmingCharacters(in: .whitespaces).isEmpty) {
            toDoService.add(toDoItem: ToDoItem(description: newToDo))  
            newToDo = ""
        }
        dismissKeyboard()
        toDoList = toDoService.toDoList
    }
    
    func delete(at offsets: IndexSet) {
        toDoService.delete(at: offsets)
        toDoList = toDoService.toDoList
    }
    
    func move(from source: IndexSet, to destination: Int) {
        toDoService.move(from: source, to: destination)
        toDoList = toDoService.toDoList
    }
}
