import SwiftUI

struct UpcomingTripCardView: View {
    let rideStatus: String // Status of the ride (e.g., Matched, Pending, Cancelled)
    let title: String      // Title of the trip (e.g., "Ride request to work")
    let date: String       // Date of the trip (e.g., "Tue, 29 Nov 2024")
    let from: String       // Starting point (e.g., "Home")
    let to: String         // Destination (e.g., "Work")
    let timeRange: String  // Time range (e.g., "07:00 - 08:00")
    let price: String      // Trip price (e.g., "R87.00")
    let onDetailsTap: () -> Void // Action for viewing details

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Status Indicator
            HStack {
                Text(rideStatus)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .foregroundColor(statusColor(for: rideStatus))
                    .background(statusBackgroundColor(for: rideStatus))
                    .cornerRadius(8)
                Spacer()
            }

            // Trip Information
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    VStack(alignment: .leading) {
                        Text(from)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text("To \(to)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(price)
                        .font(.headline)
                        .fontWeight(.bold)
                }

                Text(timeRange)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // View Details Button
            Button(action: onDetailsTap) {
                Text("View Details")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }

    // Helper: Status Text Color
    private func statusColor(for status: String) -> Color {
        switch status {
        case "Matched": return .green
        case "Cancelled": return .red
        case "In Progress": return .blue
        default: return .gray
        }
    }

    // Helper: Status Background Color
    private func statusBackgroundColor(for status: String) -> Color {
        switch status {
        case "Matched": return Color.green.opacity(0.2)
        case "Cancelled": return Color.red.opacity(0.2)
        case "In Progress": return Color.blue.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
}
