import SwiftUI

// MARK: - Input Container
private struct InputContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
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

// MARK: - Custom Text Fields
public struct CustomTextField: View {
    let text: Binding<String>
    let placeholder: String
    let icon: String
    
    public init(text: Binding<String>, placeholder: String, icon: String) {
        self.text = text
        self.placeholder = placeholder
        self.icon = icon
    }
    
    public var body: some View {
        InputContainer {
            Image(systemName: icon)
            TextField("", text: text)
                .customPlaceholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6))
                }
                .customWhiteTextStyle()
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

struct CustomSecureField: View {
    let text: Binding<String>
    let placeholder: String
    let icon: String
    
    init(text: Binding<String>, placeholder: String, icon: String) {
        self.text = text
        self.placeholder = placeholder
        self.icon = icon
    }
    
    var body: some View {
        InputContainer {
            Image(systemName: icon)
            SecureField("", text: text)
                .customPlaceholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6))
                }
                .customWhiteTextStyle()
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

// MARK: - Custom Date Picker
struct CustomDatePicker: View {
    let title: String
    let selection: Binding<Date>
    
    init(title: String, selection: Binding<Date>) {
        self.title = title
        self.selection = selection
    }
    
    var body: some View {
        InputContainer {
            Image(systemName: "calendar")
            DatePicker(
                title,
                selection: selection,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .customWhiteTextStyle()
        }
    }
}

// MARK: - Preview Provider
#Preview {
    ZStack {
        AppBackgroundGradient()
        VStack(spacing: 20) {
            CustomTextField(
                text: .constant(""),
                placeholder: "Username",
                icon: "person.fill"
            )
            
            CustomSecureField(
                text: .constant(""),
                placeholder: "Password",
                icon: "lock.fill"
            )
            
            CustomDatePicker(
                title: "Date of Birth",
                selection: .constant(Date())
            )
        }
        .padding()
    }
} 