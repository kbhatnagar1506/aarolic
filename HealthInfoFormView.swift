import SwiftUI
import UniformTypeIdentifiers

struct HealthInfoFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    
    @State private var bloodType = "Select Blood Type"
    @State private var weight = ""
    @State private var height = ""
    @State private var familyHistory = ""
    @State private var allergies = ""
    @State private var insuranceCompany = ""
    
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var progressHeader: some View {
        VStack(spacing: 15) {
            Text("Step 2 of 2")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            // Progress Steps
            HStack(spacing: 4) {
                // Personal Info Step
                StepIndicator(
                    title: "Personal Info",
                    state: .completed
                )
                
                // Connector
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 2)
                
                // Health Profile Step
                StepIndicator(
                    title: "Health Profile",
                    state: .current
                )
            }
            .padding(.horizontal)
        }
    }
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    headerView
                        .padding(.top)
                    
                    progressHeader
                    
                    formFields
                    
                    nextButton
                        .padding(.bottom, 30)
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                // Animate form appearance
            }
        }
        .onAppear(perform: loadExistingData)
        .alert("Message", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("Health Information")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 20) {
                    Group {
                        // Blood Type Selection
                        Menu {
                            ForEach(HealthProfile.bloodTypes, id: \.self) { type in
                                Button(type) {
                                    bloodType = type
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "drop.fill")
                                Text(bloodType)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                        }
                        
                        // Weight and Height
                        HStack {
                            BasicTextField(text: $weight, placeholder: "Weight (kg)", icon: "scalemass.fill")
                                .keyboardType(.decimalPad)
                            BasicTextField(text: $height, placeholder: "Height (cm)", icon: "ruler.fill")
                                .keyboardType(.decimalPad)
                        }
                        
                        // Family History
                        BasicTextField(text: $familyHistory, placeholder: "Family Medical History", icon: "person.2.fill")
                        
                        // Allergies
                        BasicTextField(text: $allergies, placeholder: "Allergies", icon: "exclamationmark.shield.fill")
                        
                        // Insurance Company
                        BasicTextField(text: $insuranceCompany, placeholder: "Insurance Company", icon: "cross.case.fill")
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 500)
    }
    
    private var nextButton: some View {
        GradientButton(
            title: "Complete Setup",
            isLoading: isLoading
        ) {
            withAnimation {
                saveHealthProfile()
            }
        }
        .padding(.horizontal)
    }
    
    private func loadExistingData() {
        if let profile = userManager.getHealthProfile() {
            bloodType = profile.bloodType
            weight = profile.weight
            height = profile.height
            familyHistory = profile.familyHistory
            allergies = profile.allergies
            insuranceCompany = profile.insuranceCompany
        }
    }
    
    private func saveHealthProfile() {
        guard validateFields() else { return }
        isLoading = true
        
        let healthProfile = HealthProfile(
            bloodType: bloodType,
            weight: weight,
            height: height,
            familyHistory: familyHistory,
            allergies: allergies,
            medicalConditions: [],
            insuranceCompany: insuranceCompany
        )
        
        userManager.saveHealthProfile(healthProfile)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            withAnimation {
                userManager.isNewUser = false  // This will show dashboard
                userManager.completeOnboarding()
            }
        }
    }
    
    private func validateFields() -> Bool {
        if bloodType == "Select Blood Type" {
            alertMessage = "Please select your blood type"
            showAlert = true
            return false
        }
        
        if weight.isEmpty || height.isEmpty {
            alertMessage = "Please enter your weight and height"
            showAlert = true
            return false
        }
        
        if insuranceCompany.isEmpty {
            alertMessage = "Please enter your insurance company"
            showAlert = true
            return false
        }
        
        return true
    }
} 