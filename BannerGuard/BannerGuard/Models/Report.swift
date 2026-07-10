import Foundation
import FirebaseFirestore

struct Report: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    var title: String
    var description: String
    var latitude: Double
    var longitude: Double
    var photoUrls: [String]
    var status: String // pending, in_progress, resolved
    let createdAt: Date
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case description
        case latitude
        case longitude
        case photoUrls
        case status
        case createdAt
        case updatedAt
    }
}