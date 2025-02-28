import SwiftUI

class DoctorManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isFirstLogin = true // Set to false after first availability setup
    @Published var schedule: DoctorSchedule = DoctorSchedule()
    
    func saveSchedule(workingDays: Set<String>, 
                     morningHours: (start: Date, end: Date),
                     eveningHours: (start: Date, end: Date),
                     workingHours: (start: Date, end: Date),
                     appointmentDuration: Int) {
        // Create schedule slots based on working hours
        schedule.generateSchedule(
            workingDays: workingDays,
            morningHours: morningHours,
            eveningHours: eveningHours,
            workingHours: workingHours,
            appointmentDuration: appointmentDuration
        )
        isFirstLogin = false
    }
}

struct DoctorSchedule {
    var weeklySchedule: [DaySchedule] = []
    
    mutating func generateSchedule(workingDays: Set<String>,
                                 morningHours: (start: Date, end: Date),
                                 eveningHours: (start: Date, end: Date),
                                 workingHours: (start: Date, end: Date),
                                 appointmentDuration: Int) {
        // Implement schedule generation logic
    }
}

struct DaySchedule: Identifiable {
    let id = UUID()
    let dayName: String
    var timeSlots: [TimeSlot]
}

struct TimeSlot: Identifiable {
    let id = UUID()
    let time: String
    let status: String
    var statusColor: Color {
        switch status {
        case "Available":
            return .green
        case "Booked":
            return .red
        default:
            return .gray
        }
    }
} 