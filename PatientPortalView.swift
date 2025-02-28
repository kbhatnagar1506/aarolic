import SwiftUI

struct PatientPortalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    @Binding var showHealthForm: Bool
    
    // Form fields
    @State private var name = ""
    @State private var dateOfBirth = Date()
    @State private var gender = "Select Gender"
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var ssn = ""
    
    // UI State
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let genderOptions = ["Male", "Female", "Other"]
    
    private var progressHeader: some View {
        VStack(spacing: 15) {
            Text("Step 1 of 2")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            // Progress Steps
            HStack(spacing: 4) {
                // Personal Info Step
                StepIndicator(
                    title: "Personal Info",
                    state: .current
                )
                
                // Connector
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 2)
                
                // Health Profile Step
                StepIndicator(
                    title: "Health Profile",
                    state: .upcoming
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
            
            Text("Patient Portal")
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
                        BasicTextField(
                            text: $name,
                            placeholder: "Full Name *",
                            icon: "person.fill"
                        )
                        
                        // Date of Birth
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.white.opacity(0.6))
                            DatePicker("Date of Birth",
                                     selection: $dateOfBirth,
                                     displayedComponents: .date)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                        
                        // Gender Selection
                        Menu {
                            ForEach(genderOptions, id: \.self) { option in
                                Button(option) {
                                    gender = option
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person.fill.questionmark")
                                    .foregroundColor(.white.opacity(0.6))
                                Text(gender)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                        }
                    }
                    
                    Group {
                        BasicTextField(
                            text: $address,
                            placeholder: "Address *",
                            icon: "house.fill"
                        )
                        
                        BasicTextField(
                            text: $city,
                            placeholder: "City *",
                            icon: "building.2.fill"
                        )
                        
                        BasicTextField(
                            text: $state,
                            placeholder: "State *",
                            icon: "map.fill"
                        )
                        
                        BasicTextField(
                            text: $zipCode,
                            placeholder: "ZIP Code *",
                            icon: "location.fill"
                        )
                            .keyboardType(.numberPad)
                    }
                    
                    Group {
                        BasicTextField(
                            text: $phoneNumber,
                            placeholder: "Phone Number *",
                            icon: "phone.fill"
                        )
                            .keyboardType(.phonePad)
                        
                        BasicTextField(
                            text: $email,
                            placeholder: "Email *",
                            icon: "envelope.fill"
                        )
                            .keyboardType(.emailAddress)
                        
                        BasicSecureField(
                            text: $ssn,
                            placeholder: "SSN *",
                            icon: "lock.shield.fill"
                        )
                            .keyboardType(.numberPad)
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 500)
        }
        .padding(.horizontal)
        .transition(.opacity)
    }
    
    private var nextButton: some View {
        GradientButton(
            title: "Next: Health Information",
            isLoading: isLoading
        ) {
            withAnimation {
                saveProfile()
            }
        }
        .padding(.horizontal)
    }
    
    private func loadExistingData() {
        if let profile = userManager.getPatientProfile() {
            name = profile.name
            dateOfBirth = profile.dateOfBirth
            gender = profile.gender
            address = profile.address
            city = profile.city
            state = profile.state
            zipCode = profile.zipCode
            phoneNumber = profile.phoneNumber
            email = profile.email
            ssn = profile.ssn
        }
    }
    
    private func saveProfile() {
        guard validateFields() else { return }
        isLoading = true
        
        let profile = PatientProfile(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            dateOfBirth: dateOfBirth,
            gender: gender,
            address: address.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            state: state.trimmingCharacters(in: .whitespacesAndNewlines),
            zipCode: zipCode.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            ssn: ssn.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        userManager.savePatientProfile(profile)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            withAnimation {
                showHealthForm = true
            }
        }
    }
    
    private func validateFields() -> Bool {
        // Implement field validation logic here
        return true
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.white.opacity(0.2))
                
                Rectangle()
                    .fill(Color("#2563EB"))
                    .frame(width: geometry.size.width * progress)
            }
            .clipShape(RoundedRectangle(cornerRadius: 3))
        }
    }
}

#Preview {
    PatientPortalView(showHealthForm: .constant(false))
        .environmentObject(UserManager())
} 
