import SwiftUI

struct GradientButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color("#2563EB"),  // Electric Blue
                                Color("#1E3A8A")   // Dark Blue
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color("#2563EB").opacity(0.5), radius: 10, x: 0, y: 4)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
            }
            .frame(height: 55)
        }
        .disabled(isLoading)
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 20) {
            GradientButton(title: "Sign In", isLoading: false) {}
            GradientButton(title: "Loading...", isLoading: true) {}
        }
        .padding()
    }
} 