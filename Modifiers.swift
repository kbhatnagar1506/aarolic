import SwiftUI

// MARK: - Custom Modifiers
struct WhiteTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .tint(.white)
    }
}

struct PlaceholderStyle<T: View>: ViewModifier {
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
    func whiteTextStyle() -> some View {
        modifier(WhiteTextStyle())
    }
    
    func withPlaceholder<T: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: @escaping () -> T
    ) -> some View {
        modifier(PlaceholderStyle(
            shouldShow: shouldShow,
            alignment: alignment,
            placeholder: placeholder
        ))
    }
}
