import SwiftUI

struct WelcomeOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    @Binding var showPersonalInfo: Bool
    let userName: String
    
    // Add state to track button press
    @State private var isLoading = false
    
    private var stepsPreview: some View {
        VStack(spacing: 20) {
            StepRow(number: 1, title: "Personal Information", subtitle: "Contact & basic details")
            StepRow(number: 2, title: "Health Profile", subtitle: "Basic health information")
        }
        .padding(.vertical, 30)
    }
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // Welcome Icon
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .symbolEffect(.bounce, options: .repeating)
                    
                    VStack(spacing: 15) {
                        Text("Welcome, \(userName)!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Complete your profile setup")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    stepsPreview
                    
                    Spacer()
                    
                    GradientButton(
                        title: "Continue Setup",
                        isLoading: isLoading
                    ) {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                showPersonalInfo = true
                                isLoading = false
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .padding()
            }
        }
    }
}

struct StepRow: View {
    let number: Int
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text("\(number)")
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.1))
        )
    }
}

#Preview {
    WelcomeOnboardingView(showPersonalInfo: .constant(false), userName: "John")
} 