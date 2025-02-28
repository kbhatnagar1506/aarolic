import Foundation

struct PatientInformation: Codable {
    let name: String
    let dateOfBirth: Date
    let gender: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let phoneNumber: String
    let email: String
    let ssn: String
    
    // Explicit coding keys
    private enum CodingKeys: String, CodingKey {
        case name
        case dateOfBirth
        case gender
        case address
        case city
        case state
        case zipCode
        case phoneNumber
        case email
        case ssn
    }
    
    // Custom encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(gender, forKey: .gender)
        try container.encode(address, forKey: .address)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(email, forKey: .email)
        try container.encode(ssn, forKey: .ssn)
    }
    
    // Custom decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        dateOfBirth = try container.decode(Date.self, forKey: .dateOfBirth)
        gender = try container.decode(String.self, forKey: .gender)
        address = try container.decode(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        ssn = try container.decode(String.self, forKey: .ssn)
    }
    
    // Regular initializer
    init(name: String, dateOfBirth: Date, gender: String, address: String, city: String, state: String, zipCode: String, phoneNumber: String, email: String, ssn: String) {
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.phoneNumber = phoneNumber
        self.email = email
        self.ssn = ssn
    }
    
    // Validation helper
    var isValid: Bool {
        !name.isEmpty &&
        gender != "Select Gender" &&
        !address.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty &&
        !zipCode.isEmpty &&
        !phoneNumber.isEmpty &&
        !email.isEmpty &&
        !ssn.isEmpty
    }
}

// Add CustomStringConvertible for better debugging
extension PatientInformation: CustomStringConvertible {
    var description: String {
        return """
        PatientInformation(
            name: \(name),
            dateOfBirth: \(dateOfBirth),
            gender: \(gender),
            address: \(address),
            city: \(city),
            state: \(state),
            zipCode: \(zipCode),
            phoneNumber: \(phoneNumber),
            email: \(email),
            ssn: ***hidden***
        )
        """
    }
} 