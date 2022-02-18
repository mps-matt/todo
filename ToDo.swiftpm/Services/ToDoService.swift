import SwiftUI
import AVFoundation

class ToDoService: ObservableObject {
    @Published private(set) var toDoList: [ToDoItem] = loadToDoList()
    
    func add(toDoItem: ToDoItem) {
        toDoList.append(toDoItem)
        saveToDoList()
    }
    
    func delete(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach { (i) in
            cancelNotification(toDoItem: toDoList[i])
        }
        
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
            
            if (toDoList[itemIndex].checked) {
                cancelNotification(toDoItem: toDoList[itemIndex])
            } else {
                scheduleNotification(toDoItem: toDoList[itemIndex])
            }
            
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
        }
        saveToDoList()
    }
    
    func editItemDescription(itemId: UUID, newDescription: String) {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            toDoList[itemIndex].description = newDescription
            cancelNotification(toDoItem: toDoList[itemIndex])
            scheduleNotification(toDoItem: toDoList[itemIndex])
        }
        saveToDoList()
    }
    
    func editItemTime(itemId: UUID, newTime: Date) {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            cancelNotification(toDoItem: toDoList[itemIndex])
            toDoList[itemIndex].dueTime = newTime
            toDoList[itemIndex].notificationSet = true
            scheduleNotification(toDoItem: toDoList[itemIndex])
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
        }
        saveToDoList()
    }
    
    func editItemNotificationString(itemId: UUID, newString: String) {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            toDoList[itemIndex].notificationUUID = newString
        }
        saveToDoList()
    }
    
    func toggleItemRepeats(itemId: UUID, dayOfWeek: Int) {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            if (toDoList[itemIndex].category == ToDoCategory.infinity && toDoList[itemIndex].repeatsOn != nil) {
                if let dayOkWeekIndex = toDoList[itemIndex].repeatsOn.firstIndex(where: { $0 == dayOfWeek}) {
                    toDoList[itemIndex].repeatsOn.remove(at: dayOkWeekIndex)
                } else {
                    toDoList[itemIndex].repeatsOn.append(dayOfWeek)
                }
                    
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
            }
        }
        saveToDoList()
    }
    
    func hasRepeatOn(itemId: UUID, dayOfWeek: Int) -> Bool {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            if (toDoList[itemIndex].category == ToDoCategory.infinity && toDoList[itemIndex].repeatsOn != nil) {
                return toDoList[itemIndex].repeatsOn.contains(dayOfWeek)
            }
        }
        return false
    }
    
    func unsetNotification(itemId: UUID) {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            toDoList[itemIndex].notificationSet = false
            cancelNotification(toDoItem: toDoList[itemIndex])
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
        }
        saveToDoList()
    }
    
    func getToDoItem(itemId: UUID) -> ToDoItem {
        if let itemIndex = toDoList.firstIndex(where: {$0.id == itemId}) {
            return toDoList[itemIndex]
        }
        
        return ToDoItem(description: "", category: ToDoCategory.none)
    }
    
    private static func loadToDoList() -> [ToDoItem] {
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
    
    private func scheduleNotification(toDoItem: ToDoItem) {
        if (toDoItem.dueTime != nil && toDoItem.notificationSet && toDoItem.category != ToDoCategory.infinity) {
            let content = UNMutableNotificationContent()
            content.title = "todoyy"
            content.body = toDoItem.description.firstLetterUppercased
            content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "CustomNotif.m4a"))
            var dateComponents = DateComponents()
            dateComponents.hour = Date.hour(date: toDoItem.dueTime ?? Date())
            dateComponents.minute = Date.minute(date: toDoItem.dueTime ?? Date())
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error : Error?) in
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                }
            }
            
            editItemNotificationString(itemId: toDoItem.id, newString: uuidString)
        }
    }
    
    private func cancelNotification(toDoItem: ToDoItem) {
        if (toDoItem.notificationUUID != nil && toDoItem.notificationUUID != "" && toDoItem.category != ToDoCategory.infinity) {
            var identifiers: [String] = []
            identifiers.append(toDoItem.notificationUUID)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
        editItemNotificationString(itemId: toDoItem.id, newString: "")
    }
    
    func handleForRepeatingTasks() {
        let todayIndex = Calendar.current.component(.weekday, from: Date())
        var yesterdayIndex = todayIndex - 1
        if (yesterdayIndex == 0) {
            yesterdayIndex = 7
        }
        
        let repeatedYesterday: [ToDoItem] = toDoList.filter {
            $0.category == ToDoCategory.daily && ($0.repeatsOn?.contains(yesterdayIndex) ?? false) 
        }
        
        let repeatsToday: [ToDoItem] = toDoList.filter { 
            $0.category == ToDoCategory.infinity && ($0.repeatsOn?.contains(todayIndex) ?? false) 
        }
        
        for repeatingTaskYesterday in repeatedYesterday {
            if let itemIndex = toDoList.firstIndex(where: {$0.id == repeatingTaskYesterday.id}) {
                delete(at: IndexSet(integer: itemIndex))
            }
        }
        
        var repeatsOnArray: [Int] = []
        repeatsOnArray.append(todayIndex)
        
        for repeatingTaskToday in repeatsToday {
            let itemIndex = toDoList.firstIndex(where: {$0.description == repeatingTaskToday.description && $0.category == ToDoCategory.daily})
            if (itemIndex == nil) {
                let newToDo = ToDoItem(description: repeatingTaskToday.description, category: ToDoCategory.daily, repeatsOn: repeatsOnArray)
                add(toDoItem: newToDo)
                
                if (repeatingTaskToday.dueTime != nil) {
                    editItemTime(itemId: newToDo.id, newTime: repeatingTaskToday.dueTime)
                }
            }
        }
    }
}
