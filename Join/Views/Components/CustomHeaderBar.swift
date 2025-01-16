import SwiftUI

struct CustomHeaderBar: View {
    let title: String
    @Binding var activeView: AccountView.ActiveView?

    var body: some View {
        ZStack {
            // Title centered on the screen
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)

            // Back button on the left
            HStack {
                Button(action: { activeView = nil }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                .padding(.leading)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 15)
        .background(Color.white) // Background color for the navigation bar
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
