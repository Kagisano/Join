import SwiftUI

struct AccountView: View {
    @State private var activeView: ActiveView? = nil // State variable to track active view

    enum ActiveView {
        case profile
        case changePassword
        case payments
        case causes
        case referFriend
        case notificationSettings
    }

    var body: some View {
        ZStack {
            if activeView == nil {
                // Main Account View
                VStack {
                    Text("Your account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    List {
                        Section {
                            accountRow(title: "Your profile", action: { activeView = .profile })
                            accountRow(title: "Change your password", action: { activeView = .changePassword })
                            accountRow(title: "Saved Places", action: { activeView = .payments })
                            accountRow(title: "Become a driver", action: { activeView = .causes })
                        }

                        Section {
                            accountRow(title: "Refer a friend", action: { activeView = .referFriend })
                            accountRow(title: "Notification settings", action: { activeView = .notificationSettings })
                        }

                        Section {
                            Button(action: {
                                // Log out action
                                print("Logged out")
                            }) {
                                HStack {
                                    Text("Log out")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.white)
                }
                .background(Color.white)
            } else {
                // Full-Screen Navigation Views
                switch activeView {
                case .profile:
                    ProfileViewWrapper(activeView: $activeView)
                case .changePassword:
                    ChangePasswordViewWrapper(activeView: $activeView)
                case .payments:
                    PaymentsViewWrapper(activeView: $activeView)
                case .causes:
                    CausesViewWrapper(activeView: $activeView)
                case .referFriend:
                    ReferFriendViewWrapper(activeView: $activeView)
                case .notificationSettings:
                    NotificationSettingsViewWrapper(activeView: $activeView)
                case .none:
                    EmptyView() // Fallback for nil state
                }
            }
        }
    }

    // Reusable row component
    private func accountRow(title: String, subtitle: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.black)
                        .font(.body)
                        .fontWeight(.medium)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right") // Right arrow
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
    }
}

// Wrapper Views with CustomHeaderBar
struct ProfileViewWrapper: View {
    @Binding var activeView: AccountView.ActiveView?

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderBar(title: "Your Profile", activeView: $activeView)
            ProfileView() // Embed the ProfileView content
        }
        .background(Color.white) // Ensures the background is consistent
    }
}

struct ChangePasswordViewWrapper: View {
    @Binding var activeView: AccountView.ActiveView?

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderBar(title: "Change Password", activeView: $activeView)
            ChangePasswordView()
        }
        .background(Color.white)
    }
}

struct PaymentsViewWrapper: View {
    @Binding var activeView: AccountView.ActiveView?

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderBar(title: "Saved Places", activeView: $activeView)
            SavedPlacesView()
        }
        .background(Color.white)
    }
}

struct CausesViewWrapper: View {
    @Binding var activeView: AccountView.ActiveView?

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderBar(title: "Become a Driver", activeView: $activeView)
            DriverApplicationView()
        }
        .background(Color.white)
    }
}

struct ReferFriendViewWrapper: View {
    @Binding var activeView: AccountView.ActiveView?

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderBar(title: "Refer a Friend", activeView: $activeView)
            ReferFriendView()
        }
        .background(Color.white)
    }
}

struct NotificationSettingsViewWrapper: View {
    @Binding var activeView: AccountView.ActiveView?

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderBar(title: "Notification Settings", activeView: $activeView)
            NotificationSettingsView()
        }
        .background(Color.white)
    }
}

// Preview
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
