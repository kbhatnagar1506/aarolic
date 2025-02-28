//
//  ContentView.swift
//  doctor
//
//  Created by Krishna Bhatnagar on 2/21/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userManager = UserManager()
    
    private struct Colors {
        static let darkBlue = Color("#1E3A8A")
        static let royalBlue = Color("#0763E5")
        static let electricBlue = Color("#2563EB")
        static let skyBlue = Color("#38BDF8")
        static let indigoAccent = Color("#4F46E5")
    }
    
    // MARK: - View States
    @State private var showMenu = false
    @State private var animateGradient = false
    @State private var showLoginView = false
    @State private var showWelcome = false
    @State private var showPersonalInfo = false
    @State private var showHealthForm = false
    @State private var showDoctorLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundGradient()
                
                Group {
                    if userManager.isAuthenticated {
                        if userManager.isNewUser {
                            if showWelcome {
                                WelcomeOnboardingView(
                                    showPersonalInfo: $showPersonalInfo,
                                    userName: userManager.userFirstName
                                )
                            } else if showPersonalInfo {
                                PatientPortalView(showHealthForm: $showHealthForm)
                            } else if showHealthForm {
                                HealthInfoFormView()
                            } else {
                                PatientDashboardView()
                            }
                        } else {
                            PatientDashboardView()
                        }
                    } else {
                        if !showMenu {
                            welcomeView
                        } else {
                            menuView
                        }
                    }
                }
            }
            
            .sheet(isPresented: $showLoginView) {
                LoginView()
                    .environmentObject(userManager)
            }
            .sheet(isPresented: $showDoctorLogin) {
                DoctorLoginView()
            }
            .onChange(of: showPersonalInfo) { newValue in
                if newValue {
                    withAnimation {
                        showWelcome = false
                    }
                }
            }
            .onChange(of: showHealthForm) { newValue in
                if newValue {
                    withAnimation {
                        showPersonalInfo = false
                    }
                }
            }
            .onChange(of: userManager.isAuthenticated) { isAuthenticated in
                withAnimation {
                    if isAuthenticated {
                        showLoginView = false
                        showMenu = false
                        showWelcome = true
                        showPersonalInfo = false
                        showHealthForm = false
                    } else {
                        showWelcome = false
                        showPersonalInfo = false
                        showHealthForm = false
                        showMenu = false
                    }
                }
            }
            .onChange(of: userManager.isNewUser) { isNewUser in
                if !isNewUser {
                    withAnimation {
                        showWelcome = false
                        showPersonalInfo = false
                        showHealthForm = false
                    }
                }
            }
        }
        .environmentObject(userManager)
    }
    
    // MARK: - Subviews
    private var welcomeView: some View {
        VStack(spacing: 10) {
            Text("AAROLIC")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                .scaleEffect(animateGradient ? 1.05 : 1.0)
                .opacity(animateGradient ? 1 : 0.8)
            
            Text("Your Health, Our Priority")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .opacity(animateGradient ? 0.8 : 0.6)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                    showMenu = true
                }
            }
        }
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale(scale: 0.8).combined(with: .opacity)
        ))
    }
    
    private var menuView: some View {
        VStack(spacing: 40) {
            // Title and Subtitle
            VStack(spacing: 10) {
                Text("AAROLIC")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                Text("Your Health, Our Priority")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, 60)
            
            Spacer()
            
            NavigationStack {
                VStack(spacing: 20) {
                    // Patient Portal Button
                    LargeNavigationButton(
                        title: "Patient Portal",
                        subtitle: "Access your health records & appointments",
                        icon: "person.text.rectangle.fill",
                        color: Colors.electricBlue,
                        delay: 0.3
                    ) {
                        showLoginView = true
                    }
                    
                    // Doctor Portal Button
                    LargeNavigationButton(
                        title: "Doctor Portal",
                        subtitle: "Access medical resources",
                        icon: "stethoscope.circle.fill",
                        color: Colors.skyBlue,
                        delay: 0.4
                    ) {
                        showDoctorLogin = true
                    }
                    
                    // Healthcare Provider Button
                    LargeNavigationButton(
                        title: "Healthcare Provider",
                        subtitle: "Manage your hospital records",
                        icon: "building.columns.fill",
                        color: Colors.royalBlue,
                        delay: 0.5,
                        action: { print("Healthcare Provider tapped") }
                    )
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
    
    // Keep LargeNavigationButton since it's specific to ContentView
    struct LargeNavigationButton: View {
        let title: String
        let subtitle: String
        let icon: String
        let color: Color
        let delay: Double
        let action: () -> Void
        
        @State private var isPressed = false
        @State private var isAnimated = false
        
        var body: some View {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                    action()
                }
            }) {
                HStack(spacing: 20) {
                    // Icon Container
                    ZStack {
                        // Glowing background
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: 76, height: 76)
                            .blur(radius: 8)
                        
                        // Icon background
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.2),
                                        .white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                        
                        // Icon
                        Image(systemName: icon)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .padding(.leading, 8)
                    
                    // Text Content
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    // Arrow
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.trailing, 12)
                }
                .padding(.vertical, 20)
                .background(
                    ZStack {
                        // Main background
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.2),
                                        .white.opacity(0.1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Subtle border
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                )
                .shadow(color: color.opacity(0.3), radius: isPressed ? 10 : 20)
                .scaleEffect(isPressed ? 0.98 : 1)
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 20)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                    isAnimated = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
