import Foundation
class PreDiagnosisViewModel: ObservableObject {
    @Published var selectedSymptoms: Set<Symptom> = []
    @Published var isLoading = false
    @Published var diagnosis: String = ""
    @Published var error: String?
    
    private let openAIService = OpenAIService()
    
    func getPreDiagnosis(additionalNotes: String) async {
        isLoading = true
        
        do {
            let result = try await openAIService.getPreDiagnosis(
                symptoms: Array(selectedSymptoms),
                additionalNotes: additionalNotes
            )
            
            DispatchQueue.main.async {
                self.diagnosis = result
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "Failed to get diagnosis: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
} 
