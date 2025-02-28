import SwiftUI

struct PreDiagnosisResultView: View {
    let diagnosis: String
    @Environment(\.dismiss) private var dismiss
    @State private var isBookingAppointment = false
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Pre-Diagnosis Results")
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
                
                // Results in ScrollView
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 20) {
                        // Diagnosis Text
                        Text(diagnosis)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.1))
                            )
                        
                        // Disclaimer
                        Text("Note: This is a preliminary analysis only. Always consult with healthcare professionals for proper diagnosis and treatment.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                }
                .background(Color.clear)
                
                // Action Buttons in footer
                VStack(spacing: 15) {
                    GradientButton(
                        title: "Book Appointment",
                        isLoading: isBookingAppointment
                    ) {
                        isBookingAppointment = true
                        // Add appointment booking action
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isBookingAppointment = false
                            // Navigate to appointment booking
                        }
                    }
                    
                    GradientButton(
                        title: "Close",
                        isLoading: false
                    ) {
                        dismiss()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
            }
        }
    }
}

#Preview {
    PreDiagnosisResultView(diagnosis: """
        Possible Conditions:
        1. Common Cold
        2. Seasonal Allergies
        3. Upper Respiratory Infection
        4. Sinusitis
        
        Severity Assessment:
        Mild to moderate symptoms suggesting a non-emergency condition.
        
        Recommended Actions:
        1. Rest and adequate hydration
        2. Over-the-counter medications for symptom relief
        3. Monitor symptoms for 24-48 hours
        4. Use saline nasal spray if congested
        5. Maintain good hand hygiene
        
        Important Notes:
        - Seek immediate medical attention if you develop:
          • High fever (above 102°F/39°C)
          • Severe headache
          • Difficulty breathing
          • Chest pain
        - Follow up with your healthcare provider if symptoms persist beyond 7 days
        - Consider COVID-19 testing based on current guidelines
        - Keep track of any new or worsening symptoms
        
        Additional Recommendations:
        1. Avoid strenuous activities while recovering
        2. Get plenty of sleep
        3. Consider using a humidifier
        4. Avoid known allergens if applicable
        5. Practice respiratory hygiene
        
        Prevention Tips:
        1. Regular hand washing
        2. Maintain social distancing when sick
        3. Use face masks in public if symptomatic
        4. Keep living spaces well-ventilated
        """)
} 
