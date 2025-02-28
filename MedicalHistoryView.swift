import SwiftUI
import UniformTypeIdentifiers

struct MedicalHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    
    @State private var searchText = ""
    @State private var selectedConditions: Set<String> = []
    @State private var comments = ""
    @State private var documents: [URL] = []
    @State private var showingDocumentPicker = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConditionsList = false
    
    private var filteredConditions: [String] {
        if searchText.isEmpty {
            return MedicalHistory.allConditions
        }
        return MedicalHistory.allConditions.filter { $0.lowercased().contains(searchText.lowercased()) }
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
                    
                    finishButton
                        .padding(.bottom, 30)
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker(urls: $documents)
        }
        .alert("Success", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if alertMessage == "Profile setup completed!" {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 20) {
                    // Medical Conditions Search
                    VStack(alignment: .leading) {
                        Text("Medical Conditions")
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Button(action: { showConditionsList.toggle() }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text(selectedConditions.isEmpty ? "Select Conditions" : "\(selectedConditions.count) selected")
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                        }
                        
                        if showConditionsList {
                            VStack {
                                // Search Bar
                                TextField("Search conditions", text: $searchText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                                
                                // Conditions List with scroll indicator
                                ScrollView(showsIndicators: true) {
                                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                                        ForEach(filteredConditions, id: \.self) { condition in
                                            Toggle(condition, isOn: Binding(
                                                get: { selectedConditions.contains(condition) },
                                                set: { isSelected in
                                                    withAnimation(.spring()) {
                                                        if isSelected {
                                                            selectedConditions.insert(condition)
                                                        } else {
                                                            selectedConditions.remove(condition)
                                                        }
                                                    }
                                                }
                                            ))
                                            .toggleStyle(ButtonToggleStyle())
                                        }
                                    }
                                }
                                .padding()
                            }
                            .frame(maxHeight: 200)
                        }
                    }
                    
                    // Comments
                    VStack(alignment: .leading) {
                        Text("Additional Comments")
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        TextEditor(text: $comments)
                            .frame(height: 100)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                            .foregroundColor(.white)
                    }
                    
                    // Document Upload
                    VStack(alignment: .leading) {
                        Text("Medical Documents")
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Button(action: { showingDocumentPicker = true }) {
                            HStack {
                                Image(systemName: "doc.fill")
                                Text("Upload Documents")
                                Spacer()
                                Text("\(documents.count) selected")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 500)
        }
    }
    
    private var finishButton: some View {
        GradientButton(
            title: "Save",
            isLoading: isLoading
        ) {
            withAnimation {
                saveMedicalHistory()
            }
        }
        .padding(.horizontal)
    }
    
    private func saveMedicalHistory() {
        isLoading = true
        
        let history = MedicalHistory(
            conditions: Array(selectedConditions),
            comments: comments,
            documents: documents.map { $0.absoluteString }
        )
        
        userManager.saveMedicalHistory(history)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            dismiss()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("Medical History")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var progressHeader: some View {
        VStack(spacing: 15) {
            Text("Step 3 of 3")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            // Progress Steps
            HStack(spacing: 4) {
                // Personal Info Step
                StepIndicator(
                    title: "Personal Info",
                    state: .completed
                )
                
                // Connector
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 2)
                
                // Health Profile Step
                StepIndicator(
                    title: "Health Profile",
                    state: .completed
                )
                
                // Connector
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 2)
                
                // Medical History Step
                StepIndicator(
                    title: "Medical History",
                    state: .current
                )
            }
            .padding(.horizontal)
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var urls: [URL]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [
            .pdf,
            .image,
            .text,
            .jpeg,
            .png
        ], asCopy: true)
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.urls = urls
        }
    }
}

struct ButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                Spacer()
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(configuration.isOn ? Color("#2563EB").opacity(0.3) : .white.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.white)
    }
}

struct StepIndicator: View {
    enum StepState {
        case completed
        case current
        case upcoming
    }
    
    let title: String
    let state: StepState
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 30, height: 30)
                
                if state == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                } else if state == .current {
                    Circle()
                        .fill(.white)
                        .frame(width: 12, height: 12)
                }
            }
            
            Text(title)
                .font(.caption2)
                .foregroundColor(state == .upcoming ? .white.opacity(0.5) : .white)
                .fixedSize()
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .completed:
            return Color("#2563EB")
        case .current:
            return Color("#2563EB").opacity(0.5)
        case .upcoming:
            return .white.opacity(0.2)
        }
    }
}