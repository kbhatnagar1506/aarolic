import SwiftUI

struct DoctorLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var doctorManager = DoctorManager()
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showAvailabilityForm = false
    @State private var showDashboard = false
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 15) {
                    Text("Doctor Login")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Login Form
                VStack(spacing: 20) {
                    // Email Field
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty) {
                            Text("Email").foregroundColor(.white.opacity(0.6))
                        }
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .whiteTextFieldStyle()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white.opacity(0.2))
                        )
                    
                    // Password Field
                    HStack {
                        if showPassword {
                            TextField("", text: $password)
                        } else {
                            SecureField("", text: $password)
                        }
                    }
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(.white.opacity(0.6))
                    }
                    .whiteTextFieldStyle()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white.opacity(0.2))
                    )
                    
                    // Login Button
                    GradientButton(
                        title: "Sign In",
                        isLoading: isLoading
                    ) {
                        login()
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showAvailabilityForm) {
            DoctorAvailabilityForm(showDashboard: $showDashboard)
        }
        .fullScreenCover(isPresented: $showDashboard) {
            DoctorDashboardView()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func login() {
        guard !isLoading else { return }
        isLoading = true
        
        // Simulate login - replace with actual authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            if doctorManager.isFirstLogin {
                showAvailabilityForm = true
            } else {
                showDashboard = true
            }
        }
    }
} 