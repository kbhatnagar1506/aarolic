import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager()
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSignUp = false
    
    var body: some View {
        ZStack {
            // Replace the existing gradient with AppBackgroundGradient
            AppBackgroundGradient()
            
            // Content
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 15) {
                    Text("Welcome Back")
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
                        .autocorrectionDisabled()
                        .whiteTextFieldStyle()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .onSubmit {
                            // Move focus to password field when return is pressed
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white.opacity(0.2))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(showError && email.isEmpty ? .red : .clear, lineWidth: 1)
                        )
                    
                    // Password Field with validation overlay
                    HStack {
                        Group {
                            if showPassword {
                                TextField("", text: $password)
                                    .placeholder(when: password.isEmpty) {
                                        Text("Password").foregroundColor(.white.opacity(0.6))
                                    }
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .whiteTextFieldStyle()
                            } else {
                                SecureField("", text: $password)
                                    .placeholder(when: password.isEmpty) {
                                        Text("Password").foregroundColor(.white.opacity(0.6))
                                    }
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .whiteTextFieldStyle()
                            }
                        }
                        .foregroundColor(.white)
                        
                        // Show/Hide password button
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white.opacity(0.2))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(showError && password.isEmpty ? .red : .clear, lineWidth: 1)
                    )
                    
                    // Error Message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 25)
                
                // Forgot Password
                Button("Forgot Password?") {
                    // Handle forgot password
                }
                .font(.footnote.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
                
                Spacer()
                
                // Login Button
                GradientButton(
                    title: "Log In",
                    isLoading: isLoading
                ) {
                    hideKeyboard()
                    login()
                }
                .padding(.horizontal, 25)
                
                // Sign Up Option
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundColor(.white.opacity(0.8))
                    Button("Sign Up") {
                        showSignUp = true
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                }
                .font(.footnote)
                .padding(.bottom, 30)
            }
            
            // Back Button
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 20)
        }
        .onChange(of: userManager.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                dismiss()
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .onSubmit {
            hideKeyboard()
            login()
        }
    }
    
    private func login() {
        guard !isLoading else { return }
        
        hideKeyboard()
        isLoading = true
        errorMessage = ""
        showError = false
        
        print("Attempting to login with email: \(email)")
        
        Task {
            do {
                try await userManager.login(email: email, password: password)
                print("Login successful")
            } catch {
                print("Login failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
}

// Helper extension for placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// Helper to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Add this view modifier at the bottom of the file
struct WhiteTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .tint(.white)
            .accentColor(.white) // This ensures cursor and selection are white
    }
}

// Add extension for easier use
extension View {
    func whiteTextFieldStyle() -> some View {
        modifier(WhiteTextFieldStyle())
    }
} 
