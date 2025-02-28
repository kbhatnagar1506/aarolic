import SwiftUI

// MARK: - Input Container
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

// MARK: - Basic Text Fields
struct BasicTextField: View {
    let text: Binding<String>
    let placeholder: String
    let icon: String
    
    var body: some View {
        InputContainer {
            Image(systemName: icon)
            TextField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6))
                }
                .whiteTextFieldStyle()
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

struct BasicSecureField: View {
    let text: Binding<String>
    let placeholder: String
    let icon: String
    
    var body: some View {
        InputContainer {
            Image(systemName: icon)
            SecureField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6))
                }
                .whiteTextFieldStyle()
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

// MARK: - Loading View
struct BasicLoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
    }
} 