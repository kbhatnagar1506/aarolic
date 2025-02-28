import SwiftUI

// MARK: - Form Components
public struct CustomFormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    public init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            content()
        }
    }
}

public struct FormMenuButton<Label: View>: View {
    let options: [String]
    let selection: Binding<String>
    let label: Label
    
    public init(
        options: [String],
        selection: Binding<String>,
        @ViewBuilder label: () -> Label
    ) {
        self.options = options
        self.selection = selection
        self.label = label()
    }
    
    public var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection.wrappedValue = option
                }
            }
        } label: {
            label
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white.opacity(0.2))
                )
        }
    }
}

// MARK: - Preview Provider
struct FormComponents_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppBackgroundGradient()
            VStack(spacing: 20) {
                CustomFormSection(title: "Personal Information") {
                    VStack {
                        Text("Sample Form Field")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white.opacity(0.2))
                    )
                }
                
                CustomFormSection(title: "Menu Example") {
                    FormMenuButton(
                        options: ["Option 1", "Option 2"],
                        selection: .constant("Option 1")
                    ) {
                        HStack {
                            Text("Select Option")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
            .padding()
        }
    }
} 