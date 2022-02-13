import SwiftUI

class ToDoService: ObservableObject {
    @Published private(set) var toDoList: [ToDoItem]
    
    init() {
        self.toDoList = []
        toDoList = loadToDoList()
    }
    
    func add(toDoItem: ToDoItem) {
        toDoList.append(toDoItem)
        saveToDoList()
    }
    
    func delete(at offsets: IndexSet) {
        toDoList.remove(atOffsets: offsets)
        saveToDoList()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        toDoList.move(fromOffsets: source, toOffset: destination)
        saveToDoList()
    }
    
    func toggleItemChecked(itemId: UUID) {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            toDoList[itemIndex].checked.toggle()
        }
        
        saveToDoList()
    }
    
    private func loadToDoList() -> [ToDoItem] {
        if let savedToDos = UserDefaults.standard.object(forKey: "todolist") as? Data, 
            let loaded = try? JSONDecoder().decode([ToDoItem].self, from: savedToDos) {
            return loaded
        }
        return []
    }
    
    private func saveToDoList() {
        if let encoded = try? JSONEncoder().encode(toDoList) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "todolist")
        }
    }
}
