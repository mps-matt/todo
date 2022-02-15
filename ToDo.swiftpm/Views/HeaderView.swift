import SwiftUI

struct HeaderView : View {
    @Binding var title: String
    @Binding var isEditable: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isEditable.toggle()
                }) {
                    Image(systemName: isEditable ? "checkmark.circle" : "square.and.pencil")
                        .foregroundColor(isEditable ? .green : .blue)
                }
            }
            HStack {
                Text(title)
                    .font(.system(size: 30, weight: .heavy, design: .default))
                Spacer()
            }
        }
        .padding()
        .buttonStyle(.plain)
    }
}
