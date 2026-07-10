import SwiftUI

struct ReportsListView: View {
    @StateObject private var vm = ReportsViewModel()
    
    var body: some View {
        NavigationStack {
            List(vm.reports) { report in
                NavigationLink(destination: ReportDetailView(report: report)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(report.title)
                            .font(.headline)
                        Text(report.status.capitalized)
                            .font(.subheadline)
                            .foregroundStyle(statusColor(report.status))
                        Text(report.createdAt, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("My Reports")
            .refreshable {
                vm.fetchReports()
            }
            .onAppear {
                vm.fetchReports()
            }
        }
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "in_progress": return .blue
        case "resolved": return .green
        default: return .gray
        }
    }
}