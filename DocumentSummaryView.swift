import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct DocumentSummaryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDocument: URL?
    @State private var documentData: Data?
    @State private var documentType: String = ""
    @State private var summary = ""
    @State private var isAnalyzing = false
    @State private var showDocumentPicker = false
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Document Summary")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
                
                ScrollView {
                    VStack(spacing: 20) {
                        if documentData == nil {
                            // Upload Section
                            VStack(spacing: 15) {
                                Image(systemName: "doc.badge.plus")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                
                                Text("Upload medical documents or charts")
                                    .foregroundColor(.white)
                                
                                Text("Supported formats: PDF, Images, Text")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                GradientButton(
                                    title: "Upload Document",
                                    isLoading: false
                                ) {
                                    showDocumentPicker = true
                                }
                            }
                            .padding(40)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                        } else {
                            // Document Preview
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Uploaded Document")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        documentData = nil
                                        selectedDocument = nil
                                        summary = ""
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                if let url = selectedDocument {
                                    Text(url.lastPathComponent)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    if documentType == "pdf" {
                                        PDFPreview(documentData: documentData!)
                                            .frame(height: 200)
                                    } else if ["jpg", "jpeg", "png"].contains(documentType) {
                                        if let uiImage = UIImage(data: documentData!) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                            
                            // Summary Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("AI Summary")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                if isAnalyzing {
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 10) {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            Text("Analyzing document...")
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                    }
                                } else {
                                    Text(summary.isEmpty ? "Summary will appear here" : summary)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            MedicalDocumentPicker(
                selectedURL: $selectedDocument,
                documentData: $documentData,
                documentType: $documentType
            )
        }
        .onChange(of: documentData) { newValue in
            if newValue != nil {
                analyzeDocument()
            }
        }
    }
    
    private func analyzeDocument() {
        isAnalyzing = true
        
        // Simulate AI analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            summary = """
            Patient: John Doe
            Age: 45
            
            Key Findings:
            - Normal blood pressure (120/80)
            - Slightly elevated cholesterol
            - No significant abnormalities in ECG
            
            Recommendations:
            1. Continue current medication
            2. Follow-up in 3 months
            3. Maintain healthy diet and exercise
            
            Additional Notes:
            Patient shows good progress since last visit.
            """
            
            isAnalyzing = false
        }
    }
}

// PDF Preview Helper
struct PDFPreview: UIViewRepresentable {
    let documentData: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let document = PDFDocument(data: documentData) {
            pdfView.document = document
        }
    }
} 