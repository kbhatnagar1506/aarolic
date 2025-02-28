import SwiftUI

// MARK: - Preview Provider
#Preview {
    ZStack {
        AppBackgroundGradient()
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    CustomTextField(
                        text: .constant(""),
                        placeholder: "Sample Text Field",
                        icon: "person.fill"
                    )
                    
                    CustomSecureField(
                        text: .constant(""),
                        placeholder: "Sample Secure Field",
                        icon: "lock.fill"
                    )
                    
                    CustomDatePicker(
                        title: "Sample Date",
                        selection: .constant(Date())
                    )
                }
                
                // Using FormSection from FormComponents.swift
                FormSection(title: "Sample Section") {
                    Text("Sample Content")
                        .foregroundColor(.white)
                }
                
                // Using CustomMenuButton from FormComponents.swift
                CustomMenuButton(
                    options: ["Option 1", "Option 2"],
                    selection: .constant("Option 1")
                ) {
                    HStack {
                        Text("Sample Menu")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                }
                
                LoadingView()
            }
            .padding()
        }
    }
}

struct VerticalProgressBar: View {
    let currentStep: Int
    let totalSteps: Int = 3
    let titles: [String] = ["Personal Info", "Health Profile", "Medical History"]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { index in
                VStack(spacing: 4) {
                    // Step circle with number
                    ZStack {
                        Circle()
                            .fill(stepColor(for: index))
                            .frame(width: 30, height: 30)
                        
                        if index < currentStep {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Text("\(index + 1)")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Step title
                    Text(titles[index])
                        .font(.caption2)
                        .foregroundColor(index <= currentStep ? .white : .white.opacity(0.5))
                }
                
                // Connector line (except for last item)
                if index < totalSteps - 1 {
                    Rectangle()
                        .fill(index < currentStep ? Color("#2563EB") : .white.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.1))
        )
    }
    
    private func stepColor(for index: Int) -> Color {
        if index < currentStep {
            return Color("#2563EB") // Completed
        } else if index == currentStep {
            return Color("#2563EB").opacity(0.5) // Current
        } else {
            return .white.opacity(0.2) // Upcoming
        }
    }
}

struct ScrollProgressView: View {
    let currentStep: Int
    let totalSteps: Int = 3
    let titles: [String] = ["Personal Info", "Health Profile", "Medical History"]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { index in
                VStack(spacing: 4) {
                    // Step circle with number
                    ZStack {
                        Circle()
                            .fill(stepColor(for: index))
                            .frame(width: 30, height: 30)
                        
                        if index < currentStep {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Text("\(index + 1)")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Step title
                    Text(titles[index])
                        .font(.caption2)
                        .foregroundColor(index <= currentStep ? .white : .white.opacity(0.5))
                        .fixedSize()
                        .rotationEffect(.degrees(0)) // Keep text horizontal
                }
                
                if index < totalSteps - 1 {
                    Rectangle()
                        .fill(index < currentStep ? Color("#2563EB") : .white.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.1))
        )
    }
    
    private func stepColor(for index: Int) -> Color {
        if index < currentStep {
            return Color("#2563EB") // Completed
        } else if index == currentStep {
            return Color("#2563EB").opacity(0.5) // Current
        } else {
            return .white.opacity(0.2) // Upcoming
        }
    }
}

