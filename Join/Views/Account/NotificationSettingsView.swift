import SwiftUI

struct NotificationSettingsView: View {
    @State private var rideRequest: Bool = true
    @State private var priorityRideRequests: Bool = false
    @State private var riderConfirmation: Bool = true
    @State private var reminderNotifications: Bool = true
    @State private var riderCancellations: Bool = true

    var body: some View {
        Form {
            Section {
                Toggle("Ride Request", isOn: $rideRequest)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                Text("Receive notifications when a rider requests a ride during your available times.")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Toggle("Priority Ride Requests", isOn: $priorityRideRequests)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                Text("Get notified only for priority ride requests (e.g., rides that offer a higher fee).")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Toggle("Rider Confirmation", isOn: $riderConfirmation)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                Text("Receive notifications when a rider accepts the earliest available time you offer.")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Toggle("Reminder Notifications", isOn: $reminderNotifications)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                Text("Receive reminders about upcoming rides, especially as the pickup time approaches.")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Toggle("Rider Cancellations", isOn: $riderCancellations)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                Text("Get notified immediately if a rider cancels a confirmed ride.")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Notification Settings")
    }
}
