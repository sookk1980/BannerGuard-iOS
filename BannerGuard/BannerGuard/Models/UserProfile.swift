import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
    let uid: String
    var name: String
    var email: String
    var phone: String
    var isAdmin: Bool = false
    var fcmToken: String?
}