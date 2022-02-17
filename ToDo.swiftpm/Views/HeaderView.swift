import SwiftUI

struct HeaderView : View {
    @Binding var title: String
    @Binding var isEditable: Bool
    @Binding var isLightMode: Bool
    @Binding var pageCategory: ToDoCategory 
    @State private var showingSheet = false
    
    @EnvironmentObject private var toDoService: ToDoService
    
    var body: some View {
        VStack {
            HStack {
                if (pageCategory == ToDoCategory.daily) {
                    Button(action: {
                        showingSheet = true
                    }) {
                        Image(systemName: "infinity")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                    .sheet(isPresented: $showingSheet) {
                        ToDoListView(
                            title: .constant("∞"),
                            toDoCategory: ToDoCategory.infinity,
                            toDoList: toDoService.toDoList,
                            isLightMode: $isLightMode
                        )
                    }
                    Button(action: {
                        self.isLightMode.toggle()
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                    }) {
                        Image(systemName: isLightMode ? "sun.min.fill" : "moon.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                Button(action: {
                    self.isEditable.toggle()
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                }) {
                    Image(systemName: isEditable ? "checkmark.circle" : "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(isEditable ? .green : .blue)
                }
            }
            HStack {
                Text(title)
                    .font(.system(size: 34, weight: .heavy, design: .default))
                Spacer()
            }
        }
        .padding()
        .buttonStyle(.plain)
    }
}
