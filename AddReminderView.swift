import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    
    @State private var medicineName = ""
    @State private var dosage = ""
    @State private var time = Date()
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    headerView
                        .padding(.top)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        BasicTextField(
                            text: $medicineName,
                            placeholder: "Medicine Name *",
                            icon: "pills.fill"
                        )
                        
                        BasicTextField(
                            text: $dosage,
                            placeholder: "Dosage (e.g., 1 Tablet) *",
                            icon: "medical.thermometer.fill"
                        )
                        
                        // Time Picker
                        VStack(alignment: .leading) {
                            Text("Reminder Time *")
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.white.opacity(0.6))
                                DatePicker("Time",
                                         selection: $time,
                                         displayedComponents: .hourAndMinute)
                                    .colorScheme(.dark)
                                    .labelsHidden()
                                    .tint(.white)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Add Button
                    GradientButton(
                        title: "Add Reminder",
                        isLoading: isLoading
                    ) {
                        saveReminder()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("Add Reminder")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func saveReminder() {
        // Validate fields
        if medicineName.isEmpty {
            alertMessage = "Please enter medicine name"
            showAlert = true
            return
        }
        
        if dosage.isEmpty {
            alertMessage = "Please enter dosage"
            showAlert = true
            return
        }
        
        isLoading = true
        
        let reminder = MedicationReminder(
            medicineName: medicineName.trimmingCharacters(in: .whitespacesAndNewlines),
            time: time,
            dosage: dosage.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        // Add to UserManager
        userManager.addReminder(reminder)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            dismiss()
        }
    }
}

#Preview {
    AddReminderView()
        .environmentObject(UserManager())
} 