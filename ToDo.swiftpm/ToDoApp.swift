import SwiftUI

@main
struct ToDoApp: App {
    let toDoService = ToDoService()
    
    var body: some Scene {
        WindowGroup {
            ToDoListView(title: "To Do", toDoList: toDoService.toDoList)
                .environmentObject(toDoService)
        }
    }
}
