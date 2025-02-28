import SwiftUI

struct AppointmentCardPreview: View {
    @State private var showPreDiagnosis = false
    let appointment: DoctorAppointment

    var body: some View {
        VStack(alignment: .leading) {
            Text(appointment.patientName)
                .font(.headline)
            Text(appointment.time)
                .font(.caption)
                .foregroundColor(.secondary)
            Button(action: {
                showPreDiagnosis = true
            }) {
                Text("View Diagnosis")
            }
            .sheet(isPresented: $showPreDiagnosis) {
                PreDiagnosisView(appointment: appointment)
            }
        }
    }
}

struct AppointmentCardPreview_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentCardPreview(
            appointment: DoctorAppointment(
                patientName: "John Doe", 
                time: "10:00 AM",
                type: "General Checkup",
                symptoms: ["Fever", "Headache"]
            )
        )
    }
} 