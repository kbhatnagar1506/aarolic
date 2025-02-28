import Foundation

struct PatientProfile: Codable {
    var name: String
    var dateOfBirth: Date
    var gender: String
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var phoneNumber: String
    var email: String
    var ssn: String
    
    var formattedAddress: String {
        "\(address), \(city), \(state) \(zipCode)"
    }
} 