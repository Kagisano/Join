import SwiftUI

struct TicketDetailsView: View {
    @State private var rideStatus: String = "Matched" // Example status for the ride

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Status Indicator
                HStack {
                    Text(rideStatus)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundColor(statusColor(for: rideStatus))
                        .background(statusBackgroundColor(for: rideStatus))
                        .cornerRadius(12)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ride request to work")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("Tue,29 Nov 2024")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // Journey Information
                VStack(spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Home")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("The Matrix")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("07:00 - 08:00")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("Work")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("FNB Merchant")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("16:00 - 17:00")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    Divider()

                    // Disclaimer Text
                    Text("You will be picked up during 7:00 - 08:00.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Text("R87.00")
                            .font(.headline)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding(.horizontal)

                // Manage My Booking
                VStack(alignment: .leading, spacing: 15) {
                    Text("Manage my trip")
                        .font(.headline)
                        .fontWeight(.bold)

                    VStack(spacing: 15) {
                        // Cancel Trip Button
                        manageButton(title: "Cancel trip", action: {
                            // Cancel Trip Action
                            rideStatus = "Cancelled" // Example action to update the status
                            print("Cancel trip tapped")
                        })

                        // Navigate Button
                        manageButton(title: "Navigate", action: {
                            // Navigate Action
                        })
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Trip Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Helper: Manage Button
    private func manageButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
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
