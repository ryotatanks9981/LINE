import Firebase

class Conversation {
    let id: String
    let members: [String]
    let latestMessage: String
    let update: Timestamp
    
    init(doc: [String: Any], id: String) {
        self.id = id
        members = doc["members"] as? [String] ?? [String]()
        latestMessage = doc["latestMessage"] as? String ?? ""
        update = doc["update"] as? Timestamp ?? Timestamp()
    }
}
