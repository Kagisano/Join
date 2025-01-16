import SwiftUI

struct CustomNavBar: View {
    @Binding var selectedTab: String

    private let tabs: [(icon: String, title: String)] = [
        ("house.fill", "Home"),
        ("calendar", "Trips"),
        ("person.fill", "Account")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.title) { tab in
                navBarButton(for: tab)
                    .frame(maxWidth: .infinity) // Distribute buttons evenly
            }
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: -2)
    }

    // MARK: - Navigation Bar Button
    private func navBarButton(for tab: (icon: String, title: String)) -> some View {
        Button(action: {
            selectedTab = tab.title
        }) {
            VStack {
                Image(systemName: tab.icon)
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == tab.title ? .black : .gray)

                Text(tab.title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab.title ? .black : .gray)
            }
            .padding(.vertical, 5) // Add vertical padding for better spacing
        }
    }
}
