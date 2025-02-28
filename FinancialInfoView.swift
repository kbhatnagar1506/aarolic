import SwiftUI

struct FinancialInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPeriod = "This Month"
    
    let periods = ["This Week", "This Month", "Last 3 Months", "This Year"]
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Financial Information")
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
                
                // Period Picker
                Picker("Time Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Summary Cards
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            FinancialSummaryCard(
                                title: "Total Revenue",
                                amount: "$5,240",
                                trend: "+12%",
                                icon: "arrow.up.right",
                                color: .green
                            )
                            
                            FinancialSummaryCard(
                                title: "Appointments",
                                amount: "48",
                                trend: "+8%",
                                icon: "person.2.fill",
                                color: .blue
                            )
                        }
                        .padding(.horizontal)
                        
                        // Recent Transactions
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Recent Transactions")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            ForEach(sampleTransactions) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct FinancialSummaryCard: View {
    let title: String
    let amount: String
    let trend: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Text(amount)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: icon)
                Text(trend)
            }
            .font(.caption)
            .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

struct Transaction: Identifiable {
    let id = UUID()
    let patientName: String
    let date: String
    let amount: String
    let type: String
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.patientName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(transaction.type) • \(transaction.date)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(transaction.amount)
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

extension FinancialInfoView {
    var sampleTransactions: [Transaction] {
        [
            Transaction(patientName: "John Doe", date: "Today", amount: "$150", type: "Consultation"),
            Transaction(patientName: "Jane Smith", date: "Yesterday", amount: "$200", type: "Treatment"),
            Transaction(patientName: "Mike Johnson", date: "2 days ago", amount: "$180", type: "Follow-up")
        ]
    }
} 