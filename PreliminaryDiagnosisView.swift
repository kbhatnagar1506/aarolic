import SwiftUI

struct PreliminaryDiagnosisView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    @State private var appointments: [Appointment] = []
    
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
                
                // Date Picker
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding()
                
                // Appointments List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(sampleAppointments) { appointment in
                            AppointmentCard(appointment: appointment)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    // Sample data
    private var sampleAppointments: [Appointment] {
        [
            Appointment(patientName: "John Doe", time: "9:00 AM", type: "General Checkup", symptoms: ["Fever", "Headache"]),
            Appointment(patientName: "Jane Smith", time: "10:30 AM", type: "Follow-up", symptoms: ["Joint Pain"]),
            Appointment(patientName: "Mike Johnson", time: "2:00 PM", type: "Consultation", symptoms: ["Cough", "Fatigue"])
        ]
    }
}

struct Appointment: Identifiable {
    let id = UUID()
    let patientName: String
    let time: String
    let type: String
    let symptoms: [String]
}

struct AppointmentCard: View {
    let appointment: Appointment
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.patientName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(appointment.type) • \(appointment.time)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reported Symptoms:")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                    
                    ForEach(appointment.symptoms, id: \.self) { symptom in
                        Text("• \(symptom)")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Button(action: {}) {
                        Text("Start Diagnosis")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.top, 5)
                }
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .animation(.spring(), value: isExpanded)
    }
} 