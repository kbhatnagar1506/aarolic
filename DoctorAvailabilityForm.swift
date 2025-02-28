import SwiftUI

struct DoctorAvailabilityForm: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showDashboard: Bool
    @StateObject private var scheduleManager = DoctorScheduleManager()
    @State private var selectedDays: Set<String> = []
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var breakTime = Date()
    @State private var appointmentDuration = 30 // minutes
    @State private var isLoading = false
    @State private var currentStep = 1
    @State private var workingStartTime = Date()
    @State private var workingEndTime = Date()
    
    // Add time slot states
    @State private var morningStartTime = Date()
    @State private var morningEndTime = Date()
    @State private var eveningStartTime = Date()
    @State private var eveningEndTime = Date()
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Progress indicator
                    Text("Step \(currentStep) of 3")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    switch currentStep {
                    case 1:
                        workingDaysView
                    case 2:
                        timeSlotsView
                    case 3:
                        workingHoursView
                    default:
                        EmptyView()
                    }
                    
                    // Navigation Buttons
                    HStack(spacing: 20) {
                        if currentStep > 1 {
                            GradientButton(
                                title: "Back",
                                isLoading: false
                            ) {
                                withAnimation {
                                    currentStep -= 1
                                }
                            }
                        }
                        
                        GradientButton(
                            title: buttonTitle,
                            isLoading: isLoading
                        ) {
                            handleNavigation()
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private var buttonTitle: String {
        switch currentStep {
        case 1, 2:
            return "Next"
        case 3:
            return "Let's Finish"
        default:
            return ""
        }
    }
    
    private var workingDaysView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Working Days")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(daysOfWeek, id: \.self) { day in
                Toggle(day, isOn: Binding(
                    get: { selectedDays.contains(day) },
                    set: { isSelected in
                        if isSelected {
                            selectedDays.insert(day)
                        } else {
                            selectedDays.remove(day)
                        }
                    }
                ))
                .toggleStyle(ButtonToggleStyle())
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
    
    private var timeSlotsView: some View {
        VStack(spacing: 20) {
            Text("Set Your Daily Hours")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                // Regular Hours
                GroupBox("Regular Hours") {
                    VStack(spacing: 15) {
                        HStack {
                            Text("Start Time")
                                .foregroundColor(.white)
                            Spacer()
                            DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .colorInvert()
                        }
                        
                        HStack {
                            Text("End Time")
                                .foregroundColor(.white)
                            Spacer()
                            DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .colorInvert()
                        }
                    }
                }
                .groupBoxStyle(TransparentGroupBox())
                
                // Break Time
                GroupBox("Break Time") {
                    HStack {
                        Text("Start")
                            .foregroundColor(.white)
                        Spacer()
                        DatePicker("", selection: $breakTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorInvert()
                    }
                }
                .groupBoxStyle(TransparentGroupBox())
                
                // Appointment Duration
                GroupBox("Appointment Settings") {
                    Stepper("Duration: \(appointmentDuration) min",
                           value: $appointmentDuration,
                           in: 15...60,
                           step: 15)
                    .foregroundColor(.white)
                }
                .groupBoxStyle(TransparentGroupBox())
            }
        }
        .padding()
    }
    
    private var workingHoursView: some View {
        VStack(spacing: 25) {
            Text("Set Schedule Duration")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                // Start Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                    Text("Start Date")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    DatePicker(
                        "",
                        selection: $workingStartTime,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .colorInvert()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                
                // End Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                    Text("End Date")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    DatePicker(
                        "",
                        selection: $workingEndTime,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .colorInvert()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
            }
        }
        .padding()
    }
    
    private func handleNavigation() {
        if currentStep < 3 {
            withAnimation {
                currentStep += 1
            }
        } else {
            saveSchedule()
        }
    }
    
    private func saveSchedule() {
        isLoading = true
        
        // Create schedule based on selected dates and times
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: workingStartTime)
        let endDate = calendar.startOfDay(for: workingEndTime)
        
        // Extract time components
        let startHour = calendar.component(.hour, from: startTime)
        let startMinute = calendar.component(.minute, from: startTime)
        let endHour = calendar.component(.hour, from: endTime)
        let endMinute = calendar.component(.minute, from: endTime)
        let breakHour = calendar.component(.hour, from: breakTime)
        let breakMinute = calendar.component(.minute, from: breakTime)
        
        // Generate schedule
        var currentDate = startDate
        while currentDate <= endDate {
            let weekday = calendar.component(.weekday, from: currentDate)
            let weekdayName = calendar.weekdaySymbols[weekday - 1]
            
            if selectedDays.contains(weekdayName) {
                // Generate time slots for this day
                var slots: [TimeSlot] = []
                var currentSlot = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: currentDate)!
                let dayEnd = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: currentDate)!
                let breakStart = calendar.date(bySettingHour: breakHour, minute: breakMinute, second: 0, of: currentDate)!
                
                while currentSlot < dayEnd {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a"
                    let timeString = formatter.string(from: currentSlot)
                    
                    // Skip break time
                    if !calendar.isDate(currentSlot, equalTo: breakStart, toGranularity: .hour) {
                        slots.append(TimeSlot(time: timeString, status: "Available"))
                    }
                    
                    currentSlot = calendar.date(byAdding: .minute, value: appointmentDuration, to: currentSlot)!
                }
                
                // Save slots for this day
                scheduleManager.setTimeSlots(for: currentDate, slots: slots)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            dismiss()
            showDashboard = true
        }
    }
}

// Add a transparent GroupBox style
struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
            configuration.content
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
} 