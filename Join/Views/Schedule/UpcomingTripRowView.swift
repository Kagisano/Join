import SwiftUI

struct UpcomingTripRowView: View {
    let destination: String
    let dateTime: String
    let price: String
    let status: String
    let onRebookTap: () -> Void

    var body: some View {
        HStack {
            // Icon
            Image(systemName: "car.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
                .padding(.trailing, 8)

            // Trip Details
            VStack(alignment: .leading, spacing: 4) {
                Text(destination)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(dateTime), \(price)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(status)
                    .font(.caption)
                    .foregroundColor(.red) // Example: Cancelled trips in red
            }

            Spacer()

            // Rebook Button
            Button(action: onRebookTap) {
                HStack {
                    Text("View")
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
