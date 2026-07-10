import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func createReport(_ report: Report, image: UIImage?) async throws -> String {
        guard let userId = Auth.auth().currentUser?.uid else { throw NSError(domain: "", code: 0) }
        
        var newReport = report
        newReport.userId = userId
        newReport.createdAt = Date()
        
        let docRef = try await db.collection("reports").addDocument(from: newReport)
        
        if let image = image {
            let photoUrl = try await uploadImage(image, reportId: docRef.documentID)
            try await docRef.updateData(["photoUrls": [photoUrl]])
        }
        
        return docRef.documentID
    }
    
    private func uploadImage(_ image: UIImage, reportId: String) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.7) else { throw NSError(domain: "", code: 1) }
        let ref = storage.reference().child("reports/\(reportId)/\(UUID().uuidString).jpg")
        _ = try await ref.putDataAsync(data)
        return try await ref.downloadURL().absoluteString
    }
    
    func fetchUserReports() async throws -> [Report] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await db.collection("reports")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Report.self) }
    }
}