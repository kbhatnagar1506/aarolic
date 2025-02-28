import SwiftUICore
import SwiftUI

struct PreDiagnosisView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var diagnosis = ""
    @State private var prescription = ""
    @State private var notes = ""
    @State private var selectedSymptoms = Set<Symptom>()
    let appointment: DoctorAppointment?  // Make it optional
    @StateObject private var openAIService = OpenAIService()
    @State private var isGeneratingPrescription = false
    @State private var showPrescriptionSheet = false
    @State private var generatedPrescription: PrescriptionDetails?
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Preliminary Diagnosis")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let appointment = appointment {
                            // Doctor's view with patient info
                            patientInfoSection(appointment: appointment)
                        } else {
                            // Patient's view with symptom selection
                            symptomSelectionSection
                        }
                        
                        // AI Suggested Diagnosis
                        VStack(alignment: .leading, spacing: 15) {
                            Text("AI Suggested Diagnosis")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                // Possible Causes
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Possible causes:")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    ForEach(suggestedDiagnosis.possibleCauses, id: \.self) { cause in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                            Text(cause)
                                        }
                                        .foregroundColor(.white.opacity(0.9))
                                    }
                                }
                                
                                // Severity Assessment
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Severity Assessment:")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(suggestedDiagnosis.severityAssessment)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                
                                // Recommended Tests
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Recommended tests:")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    ForEach(suggestedDiagnosis.recommendedTests, id: \.self) { test in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                            Text(test)
                                        }
                                        .foregroundColor(.white.opacity(0.9))
                                    }
                                }
                                
                                // Additional Recommendations
                                if !suggestedDiagnosis.additionalRecommendations.isEmpty {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Additional Recommendations:")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        ForEach(suggestedDiagnosis.additionalRecommendations, id: \.self) { recommendation in
                                            HStack(alignment: .top, spacing: 8) {
                                                Text("•")
                                                Text(recommendation)
                                            }
                                            .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                        }
                        .padding()
                        
                        if appointment != nil {
                            // Doctor-only sections
                            doctorSections
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var symptomSelectionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Your Symptoms")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(symptomCategories) { category in
                CategoryCard(
                    category: category,
                    selectedSymptoms: $selectedSymptoms
                )
            }
        }
    }
    
    private func patientInfoSection(appointment: DoctorAppointment) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Patient Information")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Text(appointment.patientName)
                    .font(.title3)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(appointment.time)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text("Reported Symptoms:")
                .foregroundColor(.white.opacity(0.8))
            
            ForEach(appointment.symptoms, id: \.self) { symptom in
                Text("• \(symptom)")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
    
    private var doctorSections: some View {
        VStack(spacing: 20) {
            // Doctor's Diagnosis
            VStack(alignment: .leading, spacing: 10) {
                Text("Doctor's Diagnosis")
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextEditor(text: $diagnosis)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            
            // Save Button
            GradientButton(
                title: "Generate Prescription",
                isLoading: isGeneratingPrescription
            ) {
                generatePrescription()
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showPrescriptionSheet) {
            if let prescription = generatedPrescription {
                PrescriptionView(prescription: prescription)
            }
        }
    }
    
    private var suggestedDiagnosis: DiagnosisSuggestion {
        let symptoms = appointment?.symptoms ?? Array(selectedSymptoms.map { $0.name })
        
        if symptoms.contains("Headache") {
            return DiagnosisSuggestion(
                possibleCauses: [
                    "Tension headache - Most likely due to stress or muscle tension",
                    "Migraine - Possible if accompanied by sensitivity to light/sound",
                    "Stress-induced headache - Common with recent stress or anxiety",
                    "Dehydration - Especially if accompanied by thirst/fatigue",
                    "Sinus pressure - If congestion or facial pain is present"
                ],
                severityAssessment: "Symptoms suggest a mild to moderate condition. No immediate emergency intervention required unless accompanied by severe symptoms like sudden onset, worst headache of life, or neurological symptoms.",
                recommendedTests: [
                    "Blood pressure measurement",
                    "Basic neurological examination",
                    "Visual acuity test",
                    "Sinus examination",
                    "Neck and shoulder muscle examination"
                ],
                additionalRecommendations: [
                    "Rest in a quiet, dark room if light sensitive",
                    "Maintain adequate hydration",
                    "Consider over-the-counter pain relievers",
                    "Apply cold or warm compress",
                    "Practice stress-reduction techniques",
                    "Monitor symptoms and maintain a headache diary"
                ]
            )
        }
        
        return DiagnosisSuggestion(
            possibleCauses: ["No specific diagnosis available for the selected symptoms"],
            severityAssessment: "Please consult with a healthcare provider for proper evaluation",
            recommendedTests: ["To be determined by healthcare provider"],
            additionalRecommendations: []
        )
    }
    
    private func generatePrescription() {
        isGeneratingPrescription = true
        
        Task {
            do {
                let prompt = createPrescriptionPrompt()
                let prescription = try await openAIService.generatePrescription(prompt: prompt)
                
                await MainActor.run {
                    self.generatedPrescription = prescription
                    self.isGeneratingPrescription = false
                    self.showPrescriptionSheet = true
                }
            } catch {
                print("Error generating prescription: \(error)")
                await MainActor.run {
                    self.isGeneratingPrescription = false
                    // Handle error appropriately
                }
            }
        }
    }
    
    private func createPrescriptionPrompt() -> String {
        """
        Based on the following medical information, generate a detailed prescription:
        
        Doctor's Diagnosis: \(diagnosis)
        
        AI Suggested Diagnosis:
        - Possible Causes: \(suggestedDiagnosis.possibleCauses.joined(separator: ", "))
        - Severity: \(suggestedDiagnosis.severityAssessment)
        - Recommended Tests: \(suggestedDiagnosis.recommendedTests.joined(separator: ", "))
        
        Generate a professional medical prescription including:
        1. Medications with dosage and frequency
        2. Duration of treatment
        3. Special instructions
        4. Follow-up recommendations
        5. Lifestyle modifications if applicable
        """
    }
}

struct CategoryCard: View {
    let category: SymptomCategory
    @Binding var selectedSymptoms: Set<Symptom>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(category.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            ForEach(category.symptoms) { symptom in
                SymptomToggle(
                    symptom: symptom,
                    isSelected: selectedSymptoms.contains(symptom)
                ) {
                    if selectedSymptoms.contains(symptom) {
                        selectedSymptoms.remove(symptom)
                    } else {
                        selectedSymptoms.insert(symptom)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct SymptomToggle: View {
    let symptom: Symptom
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(symptom.name)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .white.opacity(0.6))
            }
        }
        .padding(.vertical, 5)
    }
}

private struct DiagnosisSuggestion {
    let possibleCauses: [String]
    let severityAssessment: String
    let recommendedTests: [String]
    let additionalRecommendations: [String]
} 
