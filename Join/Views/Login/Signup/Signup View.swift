import SwiftUI
import FirebaseAuth

struct SignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var signUpSuccessful = false // Track sign-up success

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.white.ignoresSafeArea()
                
                VStack {
                    // Header
                    Text("Create Account")
                        .font(.largeTitle)
                        .padding(.top, 60) // Space from the top

                    Spacer(minLength: 40) // Space between the header and input fields

                    // Email Input
                    inputField(title: "Email Address", placeholder: "Enter your email", text: $email)

                    Spacer(minLength: 16) // Space between email input and password input

                    // Password Input
                    secureInputField(title: "Password", placeholder: "Enter your password", text: $password)

                    Spacer(minLength: 16) // Space between password input and sign-up button

                    // Sign Up Button
                    actionButton(title: "Sign Up", action: {
                        signUp()
                    })

                    Spacer(minLength: 16) // Space between sign-up button and navigation

                    // Navigate to Profile Setup if sign-up is successful
                    NavigationLink(
                        destination: ProfileSetupView(),
                        isActive: $signUpSuccessful // Binding to navigation state
                    ) {
                        EmptyView()
                    }
                    
                    Spacer() // Pushes content to the center
                }
                .padding(.horizontal, 20) // Increased horizontal padding for the entire view
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }

    // Helper function for input fields
    private func inputField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(Font.custom("Roboto", size: 14).weight(.medium))
                .foregroundColor(.black)
            TextField(placeholder, text: text)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .frame(maxWidth: .infinity)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                )
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
    }

    // Helper function for secure input fields
    private func secureInputField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(Font.custom("Roboto", size: 14).weight(.medium))
                .foregroundColor(.black)
            SecureField(placeholder, text: text)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .frame(maxWidth: .infinity)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                )
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
    }

    // Helper function for action buttons
    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Font.custom("Roboto", size: 16).weight(.medium))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 42, maxHeight: 42)
                .background(Color.black)
                .cornerRadius(8)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "Account created successfully!"
                showAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    signUpSuccessful = true // Navigate after showing the alert
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
