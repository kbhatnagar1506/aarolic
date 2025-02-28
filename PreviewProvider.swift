import SwiftUI

// MARK: - Component Preview
struct ComponentPreview: View {
    var body: some View {
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
                    
                    CustomFormSection(title: "Sample Section") {
                        Text("Sample Content")
                            .foregroundColor(.white)
                    }
                    
                    FormMenuButton(
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
                    
                    CustomLoadingView()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ComponentPreview()
} 