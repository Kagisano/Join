import SwiftUI
import UIKit

struct DriverApplicationView: View {
    @State private var selectedDocument: String? = nil
    @State private var uploadedImages: [String: UIImage] = [:]
    @State private var showCamera: Bool = false
    @State private var consentGiven: Bool = false
    @State private var showConfirmation: Bool = false

    var body: some View {
        Form {
            Section(header: Text("Upload Documents")) {
                ForEach(documentList, id: \.self) { document in
                    HStack {
                        Text(document)
                        Spacer()
                        Image(systemName: uploadedImages[document] != nil ? "checkmark.circle.fill" : "camera")
                            .foregroundColor(uploadedImages[document] != nil ? .green : .blue)
                            .onTapGesture {
                                selectedDocument = document
                                showCamera = true
                            }
                    }
                }
            }

            Section {
                Toggle("I consent to a background check (MIE)", isOn: $consentGiven)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }

            Button(action: {
                if consentGiven {
                    // Submit application logic
                    showConfirmation = true
                }
            }) {
                Text("Submit Application")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(consentGiven ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!consentGiven)
        }
        .navigationTitle("Driver Application")
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera) { image in
                if let document = selectedDocument {
                    uploadedImages[document] = image
                }
            }
        }
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("Application Submitted"),
                message: Text("Thank you for applying! Your application will be reviewed."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // List of documents to be uploaded
    private var documentList: [String] {
        ["Proof of Residence", "ID Document/Passport", "Proof of Insurance", "Driver's License"]
    }
}
