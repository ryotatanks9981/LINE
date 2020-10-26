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
        store.collection("conversations").getDocuments { (snapshots, err) in
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
        store.collection("conversations").document(conversationID).getDocument { (snap, err) in
            guard snap?.data() != nil, err == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 新しい会話を作成
    public func createNewConversation(email: String, partnerEmail: String) {
        let docData: [String: Any] = [
            "members": [email, partnerEmail],
            "update": Timestamp(),
            "latestMessage": "",
        ]
        
        
        let conversationID = "\(email)_\(partnerEmail)"
        
        store.collection("conversations").document(conversationID).setData(docData) { (error) in
            guard error == nil else {
                return
            }
        }
    }
    
    //　自分のトーク履歴だけ取得
    public func getCurrentUserConversations(email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        store.collection("conversations").getDocuments { (snapshots, error) in
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

}


