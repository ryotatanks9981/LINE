import Firebase

class Post {
    
    let owner: String
    let content: String
    let createdAt: Timestamp
    
    init(doc: [String: Any]) {
        owner = doc["owner"] as? String ?? ""
        content = doc["content"] as? String ?? ""
        createdAt = doc["createdAt"] as? Timestamp ?? Timestamp()
    }
}
