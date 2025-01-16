import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var surname: String = ""
    @Published var personalEmail: String = ""
    @Published var dateOfBirth: String = ""
    @Published var cellphone: String = ""
    @Published var companyId: String = ""
    @Published var accountStatus: String = ""

    enum EditingField {
        case name, email, dob, cellphone
    }

    private let userService = UserService()

    func loadUserData() {
        userService.fetchUserData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    self?.firstName = userData["firstName"] as? String ?? ""
                    self?.surname = userData["surname"] as? String ?? ""
                    self?.personalEmail = userData["personalEmail"] as? String ?? ""
                    self?.cellphone = userData["cellphone"] as? String ?? ""
                    self?.companyId = userData["companyId"] as? String ?? ""
                    self?.accountStatus = userData["accountStatus"] as? String ?? ""
                    self?.dateOfBirth = userData["dateOfBirth"] as? String ?? ""
                case .failure(let error):
                    print("Failed to fetch user data: \(error.localizedDescription)")
                }
            }
        }
    }

    func saveUserData() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }

        let updatedData: [String: Any] = [
            "firstName": firstName,
            "surname": surname,
            "personalEmail": personalEmail,
            "cellphone": cellphone,
            "companyId": companyId,
            "dateOfBirth": dateOfBirth
        ]

        userService.saveUserData(userUID: userUID, data: updatedData) { error in
            if let error = error {
                print("Failed to save changes: \(error.localizedDescription)")
            } else {
                print("Changes saved successfully!")
            }
        }
    }
}
