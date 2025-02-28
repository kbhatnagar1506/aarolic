import SwiftUI

class DoctorScheduleManager: ObservableObject {
    @Published private var schedule: [Date: [TimeSlot]] = [:]
    
    func setTimeSlots(for date: Date, slots: [TimeSlot]) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        schedule[normalizedDate] = slots
    }
    
    func isDateAvailable(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        return schedule[normalizedDate] != nil
    }
    
    func timeSlots(for date: Date) -> [TimeSlot] {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        return schedule[normalizedDate] ?? []
    }
    
    func bookTimeSlot(date: Date, time: String) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        if var slots = schedule[normalizedDate] {
            if let index = slots.firstIndex(where: { $0.time == time }) {
                slots[index] = TimeSlot(time: time, status: "Booked")
                schedule[normalizedDate] = slots
            }
        }
    }
} 