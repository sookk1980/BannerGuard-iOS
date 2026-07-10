import SwiftUI
import FirebaseFirestore

@MainActor
class ReportDetailViewModel: ObservableObject {
    @Published var report: Report
    @Published var editedTitle: String
    @Published var editedDescription: String
    @Published var showSuccess = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    init(report: Report) {
        self.report = report
        self.editedTitle = report.title
        self.editedDescription = report.description
    }
    
    func saveUpdates() async {
        isLoading = true
        defer { isLoading = false }
        guard let id = report.id else { return }
        do {
            let docRef = db.collection("reports").document(id)
            try await docRef.updateData([
                "title": editedTitle,
                "description": editedDescription,
                "updatedAt": Date()
            ])
            report.title = editedTitle
            report.description = editedDescription
            report.updatedAt = Date()
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateStatus(newStatus: String) async {
        isLoading = true
        defer { isLoading = false }
        guard let id = report.id else { return }
        do {
            let docRef = db.collection("reports").document(id)
            try await docRef.updateData([
                "status": newStatus,
                "updatedAt": Date()
            ])
            report.status = newStatus
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}