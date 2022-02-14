import SwiftUI

@main
struct ToDoApp: App {
    @Environment(\.scenePhase) var scenePhase
    let toDoService = ToDoService()
    
    @State private var todayMessage: String = ToDoApp.getTodayMessage()
    
    var body: some Scene {
        WindowGroup {
            ToDoListView(title: $todayMessage, toDoList: toDoService.toDoList)
                .environmentObject(toDoService)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                todayMessage = ToDoApp.getTodayMessage()
            }
        }
    }
    
    static func getTodayMessage() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return (dateFormatter.string(from: Date()).lowercased())
    }
}
