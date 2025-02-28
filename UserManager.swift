import SwiftUI

class UserManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published private var currentUser: User?
    @Published var isNewUser = true  // This controls onboarding vs dashboard
    
    private let userDefaults = UserDefaults.standard
    private let usersKey = "stored_users"
    private let patientInfoKey = "patient_information_"  // Will append user ID
    private let patientProfileKey = "patient_profile_"  // Will append user ID
    private let healthProfileKey = "health_profile_"  // Will append user ID
    private let medicalHistoryKey = "medical_history_"  // Will append user ID
    
    @Published private var reminders: [MedicationReminder] = []
    @Published private var medicalRecords: [MedicalRecord] = []
    private let medicalRecordsKey = "medical_records_"  // Will append user ID
    private let remindersKey = "reminders_"  // Will append user ID
    
    init() {
        loadUsers()
        // Print stored users for debugging
        print("Stored users: \(users)")
    }
    
    // Store users
    private var users: [User] {
        get {
            if let data = userDefaults.data(forKey: usersKey),
               let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                print("Retrieved users: \(decodedUsers)")
                return decodedUsers
            }
            print("No users found in storage")
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefaults.set(encoded, forKey: usersKey)
                userDefaults.synchronize() // Force save
                print("Saved users: \(newValue)")
            }
        }
    }
    
    private func loadUsers() {
        // Load users from UserDefaults when app starts
        _ = users
    }
    
    func login(email: String, password: String) async throws {
        print("Attempting login with email: \(email)")
        
        // Basic validation
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        guard !password.isEmpty else { throw AuthError.emptyPassword }
        guard email.contains("@") else { throw AuthError.invalidEmail }
        guard password.count >= 6 else { throw AuthError.passwordTooShort }
        
        // Print all stored users for debugging
        print("All stored users: \(users)")
        
        // Check if user exists and password matches
        if let user = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
            print("Found user: \(user)")
            if user.password == password {
                print("Password matches, logging in")
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                }
            } else {
                print("Password doesn't match")
                throw AuthError.invalidCredentials
            }
        } else {
            print("No user found with email: \(email)")
            throw AuthError.userNotFound
        }
    }
    
    func signUp(fullName: String, email: String, password: String) async throws {
        // Validate inputs
        guard !fullName.isEmpty else { throw AuthError.emptyName }
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        guard !password.isEmpty else { throw AuthError.emptyPassword }
        guard email.contains("@") else { throw AuthError.invalidEmail }
        guard password.count >= 6 else { throw AuthError.passwordTooShort }
        
        let lowerEmail = email.lowercased()
        
        // Check if user exists
        guard !users.contains(where: { $0.email.lowercased() == lowerEmail }) else {
            throw AuthError.emailAlreadyExists
        }
        
        // Create new user with isNewUser set to true
        let newUser = User(
            id: UUID(),
            fullName: fullName,
            email: lowerEmail,
            password: password,
            createdAt: Date(),
            isNewUser: true  // Make sure this is set to true
        )
        
        // Save user
        var updatedUsers = users
        updatedUsers.append(newUser)
        users = updatedUsers
        
        // Auto login
        await MainActor.run {
            self.currentUser = newUser
            self.isAuthenticated = true
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
    
    // Get user profile
    func getUserProfile(email: String) -> User? {
        users.first(where: { $0.email.lowercased() == email.lowercased() })
    }
    
    func savePatientInformation(_ info: PatientInformation) {
        guard let userId = currentUser?.id.uuidString else { return }
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(info)
            userDefaults.set(encoded, forKey: patientInfoKey + userId)
            userDefaults.synchronize()
        } catch {
            print("Error saving patient information: \(error)")
        }
    }
    
    func getPatientInformation() -> PatientInformation? {
        guard let userId = currentUser?.id.uuidString else { return nil }
        if let data = userDefaults.data(forKey: patientInfoKey + userId) {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(PatientInformation.self, from: data)
            } catch {
                print("Error retrieving patient information: \(error)")
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Patient Profile Management
    func savePatientProfile(_ profile: PatientProfile) {
        guard let userId = currentUser?.id.uuidString else { return }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(profile)
            userDefaults.set(encoded, forKey: patientProfileKey + userId)
            userDefaults.synchronize()
            print("Saved profile for user: \(userId)")
        } catch {
            print("Error saving patient profile: \(error)")
        }
    }
    
    func getPatientProfile() -> PatientProfile? {
        guard let userId = currentUser?.id.uuidString else { return nil }
        
        if let data = userDefaults.data(forKey: patientProfileKey + userId) {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let profile = try decoder.decode(PatientProfile.self, from: data)
                print("Retrieved profile for user: \(userId)")
                return profile
            } catch {
                print("Error retrieving patient profile: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func saveHealthProfile(_ profile: HealthProfile) {
        guard let userId = currentUser?.id.uuidString else { return }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(profile)
            userDefaults.set(encoded, forKey: healthProfileKey + userId)
            userDefaults.synchronize()
            print("Saved health profile for user: \(userId)")
            
            // Mark onboarding as complete after saving health profile
            completeOnboarding()
        } catch {
            print("Error saving health profile: \(error)")
        }
    }
    
    func getHealthProfile() -> HealthProfile? {
        guard let userId = currentUser?.id.uuidString else { return nil }
        
        if let data = userDefaults.data(forKey: healthProfileKey + userId) {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(HealthProfile.self, from: data)
            } catch {
                print("Error retrieving health profile: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func completeOnboarding() {
        isNewUser = false  // This will trigger the dashboard view
        // Save to UserDefaults or other persistence
        UserDefaults.standard.set(false, forKey: "isNewUser")
    }
    
    // Add these computed properties
    var userName: String {
        return currentUser?.fullName ?? ""
    }
    
    var userFirstName: String {
        return userName.components(separatedBy: " ").first ?? ""
    }
    
    // Add function to save medical history
    func saveMedicalHistory(_ history: MedicalHistory) {
        guard let userId = currentUser?.id.uuidString else { return }
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(history)
            userDefaults.set(encoded, forKey: medicalHistoryKey + userId)
            
            // Create a medical record entry
            let record = MedicalRecord(
                title: "Medical History Update",
                date: Date(),
                type: .medicalHistory,
                details: "\(history.conditions.count) conditions, \(history.documents.count) documents"
            )
            addMedicalRecord(record)
            
            userDefaults.synchronize()
            print("Saved medical history for user: \(userId)")
        } catch {
            print("Error saving medical history: \(error)")
        }
    }
    
    // Add function to get medical history
    func getMedicalHistory() -> MedicalHistory? {
        guard let userId = currentUser?.id.uuidString else { return nil }
        
        if let data = userDefaults.data(forKey: medicalHistoryKey + userId) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(MedicalHistory.self, from: data)
            } catch {
                print("Error retrieving medical history: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func addReminder(_ reminder: MedicationReminder) {
        reminders.append(reminder)
        saveReminders()
        objectWillChange.send()
    }
    
    func getReminders() -> [MedicationReminder] {
        loadReminders()
        return reminders
    }
    
    private func saveReminders() {
        guard let userId = currentUser?.id.uuidString else { return }
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(reminders)
            userDefaults.set(encoded, forKey: remindersKey + userId)
            userDefaults.synchronize()
        } catch {
            print("Error saving reminders: \(error)")
        }
    }
    
    private func loadReminders() {
        guard let userId = currentUser?.id.uuidString else { return }
        if let data = userDefaults.data(forKey: remindersKey + userId) {
            do {
                let decoder = JSONDecoder()
                reminders = try decoder.decode([MedicationReminder].self, from: data)
            } catch {
                print("Error loading reminders: \(error)")
            }
        }
    }
    
    func addMedicalRecord(_ record: MedicalRecord) {
        medicalRecords.insert(record, at: 0)  // Add to beginning of array
        saveMedicalRecords()
    }
    
    func getMedicalRecords() -> [MedicalRecord] {
        return medicalRecords
    }
    
    private func saveMedicalRecords() {
        guard let userId = currentUser?.id.uuidString else { return }
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(medicalRecords)
            userDefaults.set(encoded, forKey: medicalRecordsKey + userId)
            userDefaults.synchronize()
        } catch {
            print("Error saving medical records: \(error)")
        }
    }
    
    enum AuthError: LocalizedError {
        case emptyEmail
        case emptyPassword
        case invalidEmail
        case passwordTooShort
        case emptyName
        case userNotFound
        case invalidCredentials
        case emailAlreadyExists
        
        var errorDescription: String? {
            switch self {
            case .emptyEmail: return "Please enter your email"
            case .emptyPassword: return "Please enter your password"
            case .invalidEmail: return "Please enter a valid email"
            case .passwordTooShort: return "Password must be at least 6 characters"
            case .emptyName: return "Please enter your name"
            case .userNotFound: return "No account found with this email"
            case .invalidCredentials: return "Invalid email or password"
            case .emailAlreadyExists: return "An account with this email already exists"
            }
        }
    }
}

// User model
struct User: Codable, Identifiable {
    let id: UUID
    let fullName: String
    let email: String
    let password: String
    let createdAt: Date
    var isNewUser: Bool = true
    
    // Add any additional user properties here
    var initials: String {
        fullName.split(separator: " ")
            .map { String($0.prefix(1).uppercased()) }
            .joined()
    }
} 