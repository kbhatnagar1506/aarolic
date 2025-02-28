import SwiftUI

struct HealthProfile: Codable {
    var bloodType: String
    var weight: String // in kg
    var height: String // in cm
    var familyHistory: String
    var allergies: String
    var medicalConditions: [String]
    var insuranceCompany: String
    
    static let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    static let commonMedicalConditions = [
        "None",
        "Asthma",
        "Diabetes",
        "Heart Disease",
        "High Blood Pressure",
        "Cancer",
        "Arthritis",
        "Depression",
        "Anxiety",
        "Other"
    ]
}

struct MedicalHistory: Codable {
    var conditions: [String]
    var comments: String
    var documents: [String] // URLs or identifiers for documents
    
    static let allConditions = [
        "Allergies",
        "Anemia",
        "Anxiety",
        "Arthritis",
        "Asthma",
        "Cancer",
        "Chronic Pain",
        "Depression",
        "Diabetes Type 1",
        "Diabetes Type 2",
        "Eczema",
        "Fibromyalgia",
        "GERD",
        "Heart Disease",
        "High Blood Pressure",
        "High Cholesterol",
        "Hypothyroidism",
        "IBS",
        "Insomnia",
        "Kidney Disease",
        "Migraine",
        "Multiple Sclerosis",
        "Osteoporosis",
        "Psoriasis",
        "Sleep Apnea",
        "Other"
    ]
} 