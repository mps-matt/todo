import SwiftUI

struct HeaderView : View {
    @Binding var title: String
    @Binding var isEditable: Bool
    @Binding var isLightMode: Bool
    
    var body: some View {
        VStack {
            HStack {
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
