import SwiftUI

struct PatientDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    @State private var showHealthForm = false
    @State private var selectedTab = 0
    @State private var showAddMedicationReminder = false
    @State private var showMedicalHistory = false
    @State private var showAddReminder = false
    @State private var showPreDiagnosis = false
    @State private var reminders: [MedicationReminder] = []
    @State private var medicalRecords: [MedicalRecord] = []
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        // Quick Actions
                        quickActionsGrid
                        
                        // Today's Reminders
                        remindersSection
                        
                        // Recent Records
                        recentRecordsSection
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showMedicalHistory) {
            MedicalHistoryView()
        }
        .sheet(isPresented: $showAddReminder) {
            AddReminderView()
        }
        .sheet(isPresented: $showPreDiagnosis) {
            PreDiagnosisView(appointment: nil)
        }
        .onAppear {
            // Load data
            reminders = userManager.getReminders()
            medicalRecords = userManager.getMedicalRecords()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("Patient Dashboard")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: { userManager.signOut() }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
    
    private var quickActionsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            QuickActionCard(
                title: "Medical History",
                icon: "doc.text.fill",
                color: Color("#2563EB")
            ) {
                showMedicalHistory = true
            }
            
            QuickActionCard(
                title: "Pre-diagnosis/\nAppointment",
                icon: "heart.text.square.fill",
                color: Color("#0763E5")
            ) {
                showPreDiagnosis = true
            }
            
            QuickActionCard(
                title: "Add Reminder",
                icon: "bell.badge.fill",
                color: Color("#4F46E5")
            ) {
                showAddReminder = true
            }
            
            QuickActionCard(
                title: "Account Info",
                icon: "person.circle.fill",
                color: Color("#1E3A8A")
            ) {
                // Action to show account info
            }
        }
    }
    
    private var remindersSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Today's Reminders")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("See All") {
                    // Action to see all reminders
                }
                .foregroundColor(.white.opacity(0.7))
            }
            
            if reminders.isEmpty {
                Text("No reminders for today")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            } else {
                ForEach(reminders) { reminder in
                    ReminderCard(reminder: reminder)
                }
            }
        }
    }
    
    private var recentRecordsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Records")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("See All") {
                    // Action to see all records
                }
                .foregroundColor(.white.opacity(0.7))
            }
            
            if medicalRecords.isEmpty {
                Text("No recent records")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            } else {
                ForEach(medicalRecords) { record in
                    RecordCard(record: record)
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(color)
                    )
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.1))
            )
        }
    }
}

struct ReminderCard: View {
    let reminder: MedicationReminder
    
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(Color("#2563EB"))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "pills.fill")
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.medicineName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(reminder.time.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(reminder.dosage)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(.white.opacity(0.2))
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.1))
        )
    }
}

struct RecordCard: View {
    let record: MedicalRecord
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: record.type.icon)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color("#2563EB"))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(record.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(record.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                if !record.details.isEmpty {
                    Text(record.details)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.1))
        )
    }
}

// MARK: - Models
struct MedicationReminder: Identifiable, Codable {
    let id = UUID()
    let medicineName: String
    let time: Date
    let dosage: String
}

struct MedicalRecord: Identifiable, Codable {
    let id = UUID()
    let title: String
    let date: Date
    let type: RecordType
    let details: String
    
    enum RecordType: String, Codable {
        case medicalHistory
        case appointment
        case test
        
        var icon: String {
            switch self {
            case .medicalHistory: return "doc.text.fill"
            case .appointment: return "calendar.badge.clock"
            case .test: return "cross.case.fill"
            }
        }
    }
}

// MARK: - Sample Data
let sampleReminders = [
    MedicationReminder(
        medicineName: "Vitamin D",
        time: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date(),
        dosage: "1 Tablet"
    ),
    MedicationReminder(
        medicineName: "Calcium",
        time: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date()) ?? Date(),
        dosage: "1 Tablet"
    )
]

let sampleRecords = [
    MedicalRecord(
        title: "Eye check-up",
        date: Date().addingTimeInterval(-7*24*60*60),
        type: .test,
        details: ""
    ),
    MedicalRecord(
        title: "Blood Test",
        date: Date().addingTimeInterval(-14*24*60*60),
        type: .test,
        details: ""
    )
]

#Preview {
    PatientDashboardView()
        .environmentObject(UserManager())
} 
