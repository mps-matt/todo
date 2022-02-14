import SwiftUI

class ToDoService: ObservableObject {
    @Published private(set) var toDoListToday: [ToDoItem] = loadToDoList()
    
    func add(toDoItem: ToDoItem) {
        toDoListToday.append(toDoItem)
        saveToDoList()
    }
    
    func delete(at offsets: IndexSet) {
        toDoListToday.remove(atOffsets: offsets)
        saveToDoList()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        toDoListToday.move(fromOffsets: source, toOffset: destination)
        saveToDoList()
    }
    
    func toggleItemChecked(itemId: UUID) {
        if let itemIndex = toDoListToday.firstIndex(where: {$0.id == itemId}) {
            toDoListToday[itemIndex].checked.toggle()
            
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
        }
        
        saveToDoList()
    }
    
    func getToDoItem(itemId: UUID) -> ToDoItem {
        if let itemIndex = toDoListToday.firstIndex(where: {$0.id == itemId}) {
            return toDoListToday[itemIndex]
        }
        
        return ToDoItem(description: "")
    }
    
    private static func loadToDoList() -> [ToDoItem] {
        if let savedToDos = UserDefaults.standard.object(forKey: "todolist") as? Data, 
            let loaded = try? JSONDecoder().decode([ToDoItem].self, from: savedToDos) {
            return loaded
        }
        return []
    }
    
    private func saveToDoList() {
        if let encoded = try? JSONEncoder().encode(toDoListToday) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "todolist")
        }
    }
    
}
