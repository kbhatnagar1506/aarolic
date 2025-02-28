import SwiftUI

// MARK: - Text Style Modifiers
struct CustomWhiteTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .tint(.white)
    }
}

struct CustomPlaceholderStyle<T: View>: ViewModifier {
    var shouldShow: Bool
    var alignment: Alignment
    let placeholder: () -> T
    
    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            content
        }
    }
}

// MARK: - View Extensions
extension View {
    func customWhiteTextStyle() -> some View {
        modifier(CustomWhiteTextStyle())
    }
    
    func customPlaceholder<T: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: @escaping () -> T
    ) -> some View {
        modifier(CustomPlaceholderStyle(
            shouldShow: shouldShow,
            alignment: alignment,
            placeholder: placeholder
        ))
    }
} 