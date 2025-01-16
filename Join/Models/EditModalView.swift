import FirebaseAuth
import FirebaseDatabase
import SwiftUI

struct EditModalView: View {
    var field: ProfileViewModel.EditingField
    @ObservedObject var viewModel: ProfileViewModel
    var onSave: () -> Void

    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text(modalTitle())
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text(modalDescription())
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                contentForField(field)
                    .padding(.horizontal)

                Spacer()

                Button(action: {
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .onAppear {
                isFocused = true
            }
            .padding(.top, 16)
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    private func contentForField(_ field: ProfileViewModel.EditingField) -> some View {
        switch field {
        case .name:
            VStack(alignment: .leading, spacing: 12) {
                textField(title: "First name", text: $viewModel.firstName)
                textField(title: "Last name", text: $viewModel.surname)
            }
        case .email:
            textField(title: "Email", text: $viewModel.personalEmail, keyboardType: .emailAddress)
        case .dob:
            textField(title: "Date of Birth", text: $viewModel.dateOfBirth)
        case .cellphone:
            textField(title: "Cellphone", text: $viewModel.cellphone, keyboardType: .phonePad)
        }
    }

    private func textField(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)

            TextField(title, text: text)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .keyboardType(keyboardType)
                .focused($isFocused)
        }
    }

    private func modalTitle() -> String {
        switch field {
        case .name: return "Update your name"
        case .email: return "Update your email"
        case .dob: return "Update your date of birth"
        case .cellphone: return "Update your cellphone"
        }
    }

    private func modalDescription() -> String {
        switch field {
        case .name: return "Please enter your name as it appears on your ID or passport."
        case .email: return "You'll use this email to get notifications, sign in, and recover your account."
        case .dob: return "Select your date of birth."
        case .cellphone: return "You'll use this cellphone number to get notifications, sign in, and recover your account."
        }
    }
}
