import SwiftUI
import BackgroundTasks

@main
struct ToDoApp: App {
    @Environment(\.scenePhase) var scenePhase
    let toDoService = ToDoService()
    
    @State private var todayMessage: String = ToDoApp.getMessage(format: "EEEE")
    @State private var monthMessage: String = ToDoApp.getMessage(format: "LLLL")
    @State private var yearMessage: String = ToDoApp.getMessage(format: "yyyy")
    
    @AppStorage("isLightMode") private var isLightMode: Bool = true
    
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.secondarySystemBackground
        
        toDoService.handleForRepeatingTasks()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]){_,_ in }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ToDoListView(
                    title: $todayMessage,
                    toDoCategory: ToDoCategory.daily,
                    toDoList: toDoService.toDoList,
                    isLightMode: $isLightMode
                )
                    .environmentObject(toDoService)
                ToDoListView(
                    title: $monthMessage,
                    toDoCategory: ToDoCategory.monthly,
                    toDoList: toDoService.toDoList,
                    isLightMode: $isLightMode
                )
                    .environmentObject(toDoService)
                ToDoListView(
                    title: $yearMessage,
                    toDoCategory: ToDoCategory.yearly,
                    toDoList: toDoService.toDoList,
                    isLightMode: $isLightMode
                )
                    .environmentObject(toDoService)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .preferredColorScheme(isLightMode ? .light : .dark)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                todayMessage = ToDoApp.getMessage(format: "EEEE")
                monthMessage = ToDoApp.getMessage(format: "LLLL")
                yearMessage = ToDoApp.getMessage(format: "yyyy")
            } else if newPhase == .background {
                scheduleBackgroundTodoFetch()
            }
        }
    }
    
    func scheduleBackgroundTodoFetch() {
        print("scheduling")
        let infinityTasksFetchTask = BGAppRefreshTaskRequest(identifier: "com.mattstark.updateTodos")
        infinityTasksFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(infinityTasksFetchTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        print("called from background!")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        toDoService.handleForRepeatingTasks()
        task.setTaskCompleted(success: true)
        scheduleBackgroundTodoFetch()
    }
    
    static func getMessage(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return (dateFormatter.string(from: Date()).lowercased())
    }
}
