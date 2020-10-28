import Foundation
import Firebase

class StoreManager {
    static let shared = StoreManager()
    
    private let store = Firestore.firestore()
    
    enum StoreError: Error {
        case failedToGetCurrentUser, failedToGetAllUser
        case failedToGetAllConversations
        case failedToCreateNewConversation
        case failedToGetCurrentUserConversations
        case fail
    }
    
    // Abous Users functions
    //   - userExists
    //   - insertUser
    //   - getCurrentUser
    //   - getAAllUser
    
    
    // ユーザーが既に存在するかどうか
    public func userExists(email: String, completion: @escaping (Bool) -> Void) {
        store.collection("users").document(email).getDocument { (snaphot, error) in
            guard snaphot?.data() != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 新しくユーザーを登録
    public func insertUser(user: User) {
        
        let docData: [String: Any] = [
            "username": user.username,
            "createdAt": user.createdAt,
            "profileImageUrl": user.profileImageUrl
        ]
        
        store.collection("users").document(user.email).setData(docData) { (error) in
            guard error == nil else {return}
        }
    }
    
    //　自分の情報をゲット
    public func getCurrentUser(with email: String, completion: @escaping (Result<User, Error>) -> Void) {
        store.collection("users").document(email).getDocument { (snapshot, error) in
            guard let data = snapshot?.data(), error == nil else {
                completion(.failure(StoreError.failedToGetCurrentUser))
                return
            }
            let user = User(doc: data, email: email)
            completion(.success(user))
        }
    }
    
    // すべてのユーザーを取得
    public func getAllUser(email: String, completion: @escaping (Result<[User], Error>) -> Void) {
        store.collection("users").getDocuments { (snapshots, err) in
            guard let docs = snapshots?.documents, err == nil else {
                completion(.failure(StoreError.failedToGetAllUser))
                return
            }
            var users = [User]()
            docs.forEach { (snapshot) in
                if snapshot.documentID != email {
                    let data = snapshot.data()
                    let user = User(doc: data, email: snapshot.documentID)
                    users.append(user)
                }
            }
            completion(.success(users))
            
        }
    }
    
    // About Conversations functions
    //   - getAllConversations
    //   - conversationExists
    //   - createNewConversation
    //   - getCurrentUserConversations
    
    
    //自分の会話を全て取得
    public func getAllConversations(email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        store.collection("conversations").addSnapshotListener { (snapshots, err) in
            guard let docs = snapshots?.documents, err == nil else {
                completion(.failure(StoreError.failedToGetAllConversations))
                return
            }
            var conversations = [Conversation]()
            docs.forEach { (snap) in
                let data = snap.data()
                let conversation = Conversation(doc: data, id: snap.documentID)
                conversation.members.forEach { (user) in
                    if user == email {
                        conversations.append(conversation)
                    }
                }
            }
            completion(.success(conversations))
        }
    }
    
    // 会話が既に存在するかどうか
    public func conversationExists(conversationID: String, completion: @escaping (Bool) -> Void) {
        store.collection("conversations").document(conversationID).getDocument { (snapshot, error) in
            guard snapshot?.data() != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 新しい会話を作成
    public func createNewConversation(email: String, partnerEmail: String) {
        var members = [email, partnerEmail]
        let docData: [String: Any] = [
            "members": members,
            "update": Timestamp(),
            "latestMessage": "",
        ]
        members = members.sorted { (fast, slow) -> Bool in
            return fast < slow
        }
        
        let conversationID = "\(members[0])_\(members[1])"
        UserDefaults.standard.set(conversationID, forKey: "conversationID")
        
        store.collection("conversations").document(conversationID).setData(docData) { (error) in
            guard error == nil else {
                return
            }
        }
    }
    
    //　自分のトーク履歴だけ取得
    public func getCurrentUserConversations(email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        store.collection("conversations").addSnapshotListener { (snapshots, error) in
            guard let docs = snapshots?.documents, error == nil else {
                completion(.failure(StoreError.failedToGetCurrentUserConversations))
                return
            }
            
            var conversations = [Conversation]()
            docs.forEach { (snaphot) in
                let members = snaphot.documentID.split(separator: "_")
                members.forEach { (member) in
                    if member == email {
                        let data = snaphot.data()
                        let conversation = Conversation(doc: data, id: snaphot.documentID)
                        conversations.append(conversation)
                    }
                }
            }
            completion(.success(conversations))
        }
    }
    
    // About Messages functions
    // - get fetchMssages
    // - insertMessage
    
    public func fetchAllMessages(conversation: Conversation, completion: @escaping (Result<[Message], Error>) -> Void) {
        store.collection("conversations").document(conversation.id).collection("messages").order(by: "date")
            .addSnapshotListener { (snapshots, error) in
                guard let docs = snapshots?.documents, error == nil else {
                    completion(.failure(StoreError.fail))
                    return
                }
                
                
                
                
                var messages = [Message]()
                
                docs.forEach { (snap) in
                    let data = snap.data()
                    let sender = Sender(senderId: data["sender"] as? String ?? "",
                                        displayName: data["dispName"] as? String ?? "")
                    let message = Message(sender: sender,
                                          messageId: snap.documentID,
                                          sentDate: data["date"] as? Date ?? Date(),
                                          kind: .text(data["content"] as? String ?? ""))
                    messages.append(message)
                }
                
                completion(.success(messages))
            }
    }
    
    public func insertMessage(id: String, message: Message, content: String) {
        let data: [String: Any] = [
            "sender": message.sender.senderId,
            "dispName": message.sender.displayName,
            "date": message.sentDate,
            "content": content
        ]
        store.collection("conversations").document(id).collection("messages").document(message.messageId).setData(data) { (err) in
            guard err == nil else {return}
        }
        
        // conversationのlatestMessageとupdateを変える
        let updateData: [String: Any] = [
            "latestMessage": content,
            "update": message.sentDate
        ]
        store.collection("conversations").document(id).setData(updateData, merge: true) { (err) in
            guard err == nil else {return}
        }
    }
    
    // About TimeLine Functions
    // - getAllPosts
    // - insertPost
    
    public func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        store.collection("posts").order(by: "createdAt", descending: true).addSnapshotListener { (snapshots, error) in
            guard let documents = snapshots?.documents, error == nil else {
                completion(.failure(StoreError.fail))
                return
            }
            
            var posts = [Post]()
            documents.forEach { (snapshot) in
                let data = snapshot.data()
                let post = Post(doc: data)
                posts.append(post)
            }
            completion(.success(posts))
        }
    }
    
    public func insertPost(post: Post) {
        let data: [String: Any] = [
            "owner": post.owner,
            "content": post.content,
            "createdAt": post.createdAt,
        ]
        
        store.collection("posts").addDocument(data: data) { (error) in
            guard error == nil else {return}
        }
    }
}


