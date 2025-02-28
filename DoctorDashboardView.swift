import SwiftUI

private struct Colors {
    static let darkBlue = Color("#1E3A8A")
    static let royalBlue = Color("#0763E5")
    static let electricBlue = Color("#2563EB")
    static let skyBlue = Color("#38BDF8")
    static let indigoAccent = Color("#4F46E5")
}

struct DoctorDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = "Dashboard"
    @State private var showAvailabilityForm = false
    @State private var showSchedule = false
    @State private var showAccountInfo = false
    @State private var showDashboard = false
    @State private var showDocumentSummary = false
    @State private var showAppointments = false
    @State private var showFinancialInfo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackgroundGradient()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Doctor Dashboard")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 15) {
                            Button(action: { showAvailabilityForm = true }) {
                                Image(systemName: "clock.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: { showAccountInfo = true }) {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.2))
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Quick Actions Grid
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 15) {
                                DoctorQuickActionCard(
                                    title: "My Schedule",
                                    icon: "calendar",
                                    color: Colors.electricBlue
                                ) {
                                    showSchedule = true
                                }
                                
                                DoctorQuickActionCard(
                                    title: "Appointments",
                                    icon: "person.2.badge.gearshape",
                                    color: Colors.royalBlue
                                ) {
                                    showAppointments = true
                                }
                                
                                DoctorQuickActionCard(
                                    title: "Charts & Documents",
                                    icon: "doc.text.magnifyingglass",
                                    color: Colors.indigoAccent
                                ) {
                                    showDocumentSummary = true
                                }
                                
                                DoctorQuickActionCard(
                                    title: "Financial Info",
                                    icon: "dollarsign.circle",
                                    color: Colors.skyBlue
                                ) {
                                    showFinancialInfo = true
                                }
                            }
                            .padding(.horizontal)
                            
                            // Upcoming Patients List
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Upcoming Patients")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                
                                ForEach(0..<5) { _ in
                                    PatientAppointmentCard()
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .sheet(isPresented: $showAvailabilityForm) {
                DoctorAvailabilityForm(showDashboard: $showDashboard)
            }
            .sheet(isPresented: $showSchedule) {
                DoctorScheduleView()
            }
            .sheet(isPresented: $showDocumentSummary) {
                DocumentSummaryView()
            }
            .sheet(isPresented: $showAppointments) {
                AppointmentsView()
            }
            .sheet(isPresented: $showFinancialInfo) {
                FinancialInfoView()
            }
            .fullScreenCover(isPresented: $showDashboard) {
                DoctorDashboardView()
            }
        }
    }
}

struct PatientAppointmentCard: View {
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text("JD")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("John Doe")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("General Checkup • 10:30 AM")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

struct DoctorQuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(color.opacity(0.2))
            .cornerRadius(15)
        }
    }
} 
