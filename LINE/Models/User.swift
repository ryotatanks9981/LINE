import Firebase


class User {
    let username: String
    let email: String
    let createdAt: Timestamp
    let profileImageUrl: String
    
    init(doc: [String: Any], email: String) {
        username = doc["username"] as? String ?? ""
        self.email = email
        profileImageUrl = doc["profileImageUrl"] as? String ?? ""
        createdAt = doc["createdAt"] as? Timestamp ?? Timestamp()
    }
}
