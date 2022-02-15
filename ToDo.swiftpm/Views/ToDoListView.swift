import SwiftUI

struct ToDoListView: View {
    @Binding var title: String
    @State var toDoCategory: ToDoCategory
    @State var toDoList: [ToDoItem]
    
    @EnvironmentObject private var toDoService: ToDoService
    
    @State private var newToDo = ""
    @State private var isEditable = false
    
    var body: some View {
        VStack {
            HeaderView(title: $title, isEditable: $isEditable)
            HStack {
                TextField("?", text: $newToDo, onCommit: addItem)
                Button("+", action: addItem)
                    .foregroundColor(.blue)
            }
            .padding()
            
            List {
                ForEach(toDoList) { toDoItem in 
                    if(toDoItem.category == toDoCategory) {
                        ToDoItemView(toDoItem: toDoItem, isEditable: $isEditable, toDoCategory: toDoItem.category)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
                .onLongPressGesture() {
                    withAnimation {
                        isEditable.toggle()
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                    }
                }
                .listRowBackground(Rectangle()
                                    .background(Color.clear)
                                    .foregroundColor(.primary)
                                    .opacity(0.07)
                )
            }
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
        }
        .textFieldStyle(.roundedBorder)
        .textInputAutocapitalization(.never)
        .buttonStyle(.bordered)
        .listStyle(.automatic)
    }
    
    func addItem() {
        if (!newToDo.trimmingCharacters(in: .whitespaces).isEmpty) {
            toDoService.add(toDoItem: ToDoItem(description: newToDo.lowercased(), category: toDoCategory))  
            newToDo = ""
        }
        dismissKeyboard()
        toDoList = toDoService.toDoList
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
    }
    
    func delete(at offsets: IndexSet) {
        toDoService.delete(at: offsets)
        toDoList = toDoService.toDoList
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        toDoService.move(from: source, to: destination)
        toDoList = toDoService.toDoList
    }
}
