import Foundation
import FirebaseDatabase
import CoreLocation

class FirebaseCompany {
    private let databaseRef = Database.database().reference().child("Company")
    
    /// Fetches company data including coordinates, name, and ride count
    func fetchCompanies(completion: @escaping ([Company]?, Error?) -> Void) {
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("No data found")
                completion([], nil)
                return
            }
            
            var companies: [Company] = []
            
            for (_, companyData) in value {
                if let companyDict = companyData as? [String: Any],
                   let name = companyDict["name"] as? String,
                   let latitude = companyDict["latitude"] as? Double,
                   let longitude = companyDict["longitude"] as? Double,
                   let rideCount = companyDict["rideCount"] as? Int {
                    let company = Company(
                        name: name,
                        latitude: latitude,
                        longitude: longitude,
                        rideCount: rideCount
                    )
                    companies.append(company)
                }
            }
            
            completion(companies, nil)
        } withCancel: { error in
            print("Error fetching companies: \(error.localizedDescription)")
            completion(nil, error)
        }
    }
}
