import SwiftUI

struct AppBackgroundGradient: View {
    @State private var backgroundOffset = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.hex("#1E3A8A"),
                    Color.hex("#0763E5"),
                    Color.hex("#2563EB").opacity(0.8),
                    Color.hex("#4F46E5").opacity(0.7),
                    Color.hex("#38BDF8").opacity(0.6),
                    Color.white.opacity(0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color.hex("#2563EB").opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(
                    x: backgroundOffset ? 120 : -120,
                    y: backgroundOffset ? -60 : 60
                )
            
            Circle()
                .fill(Color.hex("#4F46E5").opacity(0.2))
                .frame(width: 400, height: 400)
                .blur(radius: 70)
                .offset(
                    x: backgroundOffset ? -120 : 120,
                    y: backgroundOffset ? 60 : -60
                )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                backgroundOffset.toggle()
            }
        }
    }
}

#Preview {
    AppBackgroundGradient()
} 