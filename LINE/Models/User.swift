import Firebase


class User {
    let username: String
    let email: String
    let createdAt: Timestamp
    let profileImageUrl: String
    let backImageViewUrl: String?
    let statusMessage: String?
    
    init(doc: [String: Any], email: String) {
        username = doc["username"] as? String ?? ""
        self.email = email
        profileImageUrl = doc["profileImageUrl"] as? String ?? ""
        createdAt = doc["createdAt"] as? Timestamp ?? Timestamp()
        backImageViewUrl = doc["backImageView"] as? String ?? ""
        statusMessage = doc["statusMessage"] as? String ?? ""
    }
}
