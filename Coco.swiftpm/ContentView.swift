import SwiftUI

struct ToDoItemView: View {
    @Binding var toDoItem: ToDoItem
    @State var saveCallback: () -> Void
    
    
    var body: some View {
        HStack {
            Image(systemName: toDoItem.checked ? "checkmark.circle.fill" : "circle")
            Text(toDoItem.description)
                .strikethrough(toDoItem.checked)
                .foregroundColor(toDoItem.checked ? .gray : .primary)
        }
        .onTapGesture {
            toDoItem.checked = !toDoItem.checked 
            saveCallback()
        }
    }
}

struct ToDoItem: Identifiable, Encodable, Decodable {
    var id = UUID()
    var description: String = ""
    var checked = false
}

struct ContentView: View {
    @State private var newToDo = ""
    @State private var toDoList: [ToDoItem]
    @State private var isEditable = false
    
    init() {
        self.toDoList = []
        _toDoList = State(initialValue: getToDoList())
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("?", text: $newToDo)
                Button("add"){
                    toDoList.append(ToDoItem(description: newToDo))
                    newToDo = ""
                    saveToDoList()
                }
            }
            .padding()
            
            List {
                ForEach($toDoList) { toDoItem in 
                    ToDoItemView(toDoItem: toDoItem, saveCallback: saveToDoList)
                }
                .onDelete(perform: delete)
                .onMove(perform: reorder)
                .onLongPressGesture() {
                    withAnimation {
                        isEditable = !isEditable
                    }
                    
                }
            }
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
        }
        .textFieldStyle (.roundedBorder)
        .buttonStyle(.borderless)
    }
    
    func delete(at offsets: IndexSet) {
        toDoList.remove(atOffsets: offsets)
        saveToDoList()
    }
    
    func reorder(from source: IndexSet, to destination: Int) {
        toDoList.move(fromOffsets: source, toOffset: destination)
        saveToDoList()
    }
    
    func saveToDoList() {
        if let encoded = try? JSONEncoder().encode(toDoList) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "todolist")
        }
    }
    
    func getToDoList() -> [ToDoItem] {
        if let savedToDos = UserDefaults.standard.object(forKey: "todolist") as? Data, 
            let loaded = try? JSONDecoder().decode([ToDoItem].self, from: savedToDos) {
            return loaded
        }
        return []
    }
}
