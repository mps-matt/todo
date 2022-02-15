import SwiftUI

@main
struct ToDoApp: App {
    @Environment(\.scenePhase) var scenePhase
    let toDoService = ToDoService()
    
    @State private var todayMessage: String = ToDoApp.getMessage(format: "EEEE")
    @State private var monthMessage: String = ToDoApp.getMessage(format: "LLLL")
    @State private var yearMessage: String = ToDoApp.getMessage(format: "yyyy")
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ToDoListView(
                    title: $todayMessage,
                    toDoCategory: ToDoCategory.daily,
                    toDoList: toDoService.toDoList
                )
                    .environmentObject(toDoService)
                ToDoListView(
                    title: $monthMessage,
                    toDoCategory: ToDoCategory.monthly,
                    toDoList: toDoService.toDoList
                )
                    .environmentObject(toDoService)
                ToDoListView(
                    title: $yearMessage,
                    toDoCategory: ToDoCategory.yearly,
                    toDoList: toDoService.toDoList
                )
                    .environmentObject(toDoService)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                todayMessage = ToDoApp.getMessage(format: "EEEE")
                monthMessage = ToDoApp.getMessage(format: "LLLL")
                yearMessage = ToDoApp.getMessage(format: "yyyy")
            }
        }
    }
    
    static func getMessage(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return (dateFormatter.string(from: Date()).lowercased())
    }
}
