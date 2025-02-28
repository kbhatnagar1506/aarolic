import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    
    // Basic sign up fields only
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header with back button
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Create Account")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    // Sign up form
                    VStack(spacing: 20) {
                        CustomTextField(
                            text: $fullName,
                            placeholder: "Full Name",
                            icon: "person.fill"
                        )
                        
                        CustomTextField(
                            text: $email,
                            placeholder: "Email",
                            icon: "envelope.fill"
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        
                        CustomSecureField(
                            text: $password,
                            placeholder: "Password",
                            icon: "lock.fill"
                        )
                        
                        CustomSecureField(
                            text: $confirmPassword,
                            placeholder: "Confirm Password",
                            icon: "lock.fill"
                        )
                    }
                    
                    // Submit Button
                    GradientButton(
                        title: "Sign Up",
                        isLoading: isLoading
                    ) {
                        validateAndSubmit()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
        }
        .alert("Message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func validateAndSubmit() {
        guard !fullName.isEmpty else {
            alertMessage = "Please enter your name"
            showingAlert = true
            return
        }
        
        guard !email.isEmpty else {
            alertMessage = "Please enter your email"
            showingAlert = true
            return
        }
        
        guard email.contains("@") else {
            alertMessage = "Please enter a valid email"
            showingAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showingAlert = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await userManager.signUp(
                    fullName: fullName,
                    email: email,
                    password: password
                )
                
                await MainActor.run {
                    userManager.isAuthenticated = true
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                    isLoading = false
                }
            }
        }
    }
} 
