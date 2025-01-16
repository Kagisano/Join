import SwiftUI

struct ChangePasswordView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Change Your Password")) {
                SecureField("Current Password", text: $currentPassword)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmPassword)
            }
            
            Button(action: {
                // Change password logic
                print("Password changed")
            }) {
                Text("Update Password")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Change Password")
    }
}
