import SwiftUI

struct ReferFriendView: View {
    var referralLink: String = "https://yourapp.com/referral"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Invite your friends to join!")
                .font(.headline)
            
            Text(referralLink)
                .foregroundColor(.blue)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button(action: {
                // Share referral link logic
                print("Referral link shared")
            }) {
                Text("Share Link")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Refer a Friend")
    }
}
