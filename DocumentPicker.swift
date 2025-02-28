import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct MedicalDocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?
    @Binding var documentData: Data?
    @Binding var documentType: String
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [
            .pdf,
            .image,
            .jpeg,
            .png,
            .text
        ]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: MedicalDocumentPicker
        
        init(_ parent: MedicalDocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Start accessing the security-scoped resource
            guard url.startAccessingSecurityScopedResource() else {
                print("Failed to access the document")
                return
            }
            
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.parent.documentData = data
                    self.parent.selectedURL = url
                    self.parent.documentType = url.pathExtension.lowercased()
                }
            } catch {
                print("Error loading document: \(error)")
            }
        }
    }
} 