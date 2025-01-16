import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    @State private var isEditing: Bool = false
    @State private var editingField: ProfileViewModel.EditingField?

    var body: some View {
        Form {
            // Profile Picture Section (No Header)
            VStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                Text("Tap to change your profile picture.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()

            // Personal Information Section
            Section(header: Text("Personal Information").font(.headline).bold()) {
                profileRow(icon: "person.fill", text: "\(viewModel.firstName) \(viewModel.surname)", editAction: {
                    openModal(for: .name)
                })
                profileRow(icon: "envelope.fill", text: viewModel.personalEmail, editAction: {
                    openModal(for: .email)
                })
                profileRow(icon: "phone.fill", text: viewModel.cellphone, editAction: {
                    openModal(for: .cellphone)
                })
            }

            // Work Information Section
            Section(header: Text("Work Information").font(.headline).bold()) {
                profileRow(icon: "briefcase.fill", text: viewModel.companyId, editAction: {})
                profileRow(icon: "checkmark.shield.fill", text: viewModel.accountStatus, editAction: {})
            }
        }
        .onAppear {
            viewModel.loadUserData()
        }
        .sheet(isPresented: $isEditing) {
            if let field = editingField {
                EditModalView(
                    field: field,
                    viewModel: viewModel,
                    onSave: {
                        viewModel.saveUserData()
                        isEditing = false
                    }
                )
            }
        }
        .onChange(of: editingField) { newValue in
            // Ensure modal opens only when editingField changes
            isEditing = newValue != nil
        }
    }

    private func profileRow(icon: String, text: String, editAction: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
            Text(text)
                .font(.system(size: 16))
            Spacer()
            Button("Edit", action: editAction)
                .foregroundColor(.black)
        }
        .padding(.vertical, 8)
    }

    private func openModal(for field: ProfileViewModel.EditingField) {
        editingField = field
    }
}
