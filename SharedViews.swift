import SwiftUI

// MARK: - Text Input Components

private struct InputContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        HStack {
            content()
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white.opacity(0.2))
        )
    }
}

// MARK: - Form Components
struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            content()
        }
    }
}

struct CustomMenuButton<Label: View>: View {
    let label: Label
    let options: [String]
    let selection: Binding<String>
    
    init(
        options: [String],
        selection: Binding<String>,
        @ViewBuilder label: () -> Label
    ) {
        self.options = options
        self.selection = selection
        self.label = label()
    }
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection.wrappedValue = option
                }
            }
        } label: {
            InputContainer {
                label
            }
        }
    }
}



// MARK: - Loading Components
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
    }
}

// MARK: - Preview Provider
struct SharedViews_Previews: PreviewProvider {
    static var previews: some View {
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
                    
                    LoadingView()
                }
                .padding()
            }
        }
    }
} 
