import SwiftUI

struct TripCardView: View {
    let fromTitle: String
    let fromLocation: String
    let fromTime: String
    let toTitle: String
    let toLocation: String
    let toTime: String
    let disclaimer: String
    let price: String
    @Binding var activeHomeView: Bool // Binding to control the view switch

    var body: some View {
        VStack(spacing: 8) { // Reduced vertical spacing
            // Profile, Chat, and Safety Row
            HStack(spacing: 40) { // Reduced horizontal spacing
                VStack {
                    // Profile Section
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemGray6)) // Light grey background
                            .frame(width: 40, height: 40) // Smaller size
                        Image(systemName: "person.badge.shield.checkmark") // New profile icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20) // Smaller icon
                            .foregroundColor(.primary)
                    }
                    Text("Limakatso")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }

                VStack {
                    // Chat Section
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemGray6)) // Light grey background
                            .frame(width: 40, height: 40) // Smaller size
                        Image(systemName: "ellipsis.message") // New chat icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20) // Smaller icon
                            .foregroundColor(.primary)
                    }
                    Text("Chat")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }

                VStack {
                    // Safety Section
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemGray6)) // Light grey background
                            .frame(width: 40, height: 40) // Smaller size
                        Image(systemName: "shield.lefthalf.filled") // New safety icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20) // Smaller icon
                            .foregroundColor(.primary)
                    }
                    Text("Safety")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            .padding(.bottom, 5) // Reduced bottom padding

            Divider()

            // Journey Information
            HStack {
                // From Section
                VStack(alignment: .leading, spacing: 5) { // Compact spacing
                    Text(fromTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(fromLocation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(fromTime)
                        .font(.headline)
                        .fontWeight(.bold)
                }

                Spacer()

                // To Section
                VStack(alignment: .trailing, spacing: 5) { // Compact spacing
                    Text(toTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(toLocation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(toTime)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }

            Divider()

            // Disclaimer Text
            Text(disclaimer)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Credit Card Icon and Price
            HStack {
                Image(systemName: "creditcard.fill") // Credit card icon on the far left
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20) // Icon size
                    .foregroundColor(.primary)
                Spacer() // Push price to the far right
                Text(price)
                    .font(.headline)
                    .fontWeight(.medium)
            }

            // Cancel Button
            Button(action: {
                activeHomeView = true // Switch back to HomeView
            }) {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black) // Black background
                    .cornerRadius(8)
            }
            .padding(.top, 10) // Spacing above the button
        }
        .padding(.vertical, 8) // Reduced vertical padding
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}
