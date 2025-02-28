import SwiftUI

struct DoctorScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scheduleManager = DoctorScheduleManager()
    @State private var selectedDate: Date = Date()
    @State private var showingTimeSlots = false
    
    private let calendar = Calendar.current
    private let daysInWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Schedule")
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
                
                // Month and Year
                HStack {
                    Text(monthYearString(from: selectedDate))
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                
                // Days of week header
                HStack {
                    ForEach(daysInWeek, id: \.self) { day in
                        Text(day)
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal)
                
                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(daysInMonth(), id: \.self) { date in
                        if let date = date {
                            DayCell(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isAvailable: scheduleManager.isDateAvailable(date)
                            )
                            .onTapGesture {
                                selectedDate = date
                                showingTimeSlots = true
                            }
                        } else {
                            Color.clear
                                .aspectRatio(1, contentMode: .fill)
                        }
                    }
                }
                .padding()
                
                if showingTimeSlots {
                    // Time slots for selected date
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(scheduleManager.timeSlots(for: selectedDate)) { slot in
                                TimeSlotView(slot: slot)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func daysInMonth() -> [Date?] {
        var days: [Date?] = []
        
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        
        // Add empty cells for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add all days in the month
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isAvailable: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .white : textColor)
        }
        .aspectRatio(1, contentMode: .fill)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue
        } else if isAvailable {
            return Color.green.opacity(0.3)
        } else {
            return Color.red.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        isAvailable ? .white : .white.opacity(0.7)
    }
}

struct TimeSlotView: View {
    let slot: TimeSlot
    
    var body: some View {
        HStack {
            Text(slot.time)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(slot.status)
                .font(.subheadline)
                .foregroundColor(slot.statusColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(slot.statusColor.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
} 