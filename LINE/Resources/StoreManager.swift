import Foundation
import Firebase
import SDWebImage

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
    //   - isFriend
    //   - fetchFriends
    //   - addFriend
    //   - deleteFriend
    
    
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
            "profileImageUrl": user.profileImageUrl,
            "backImageViewUrl": user.backImageViewUrl ?? "",
            "statusMessage": user.statusMessage ?? "",
        ]
        
        store.collection("users").document(user.email).setData(docData, merge: true) { (error) in
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
    
    public func fetchFriends(email: String, completion: @escaping (Result<[String], Error>) -> Void) {
        store.collection("users").document(email).collection("friends").addSnapshotListener { (snapshots, err) in
            guard let documents = snapshots?.documents, err == nil else {
                completion(.failure(StoreError.fail))
                return
            }
            var friends = [String]()
            documents.forEach { (snashot) in
                let email = snashot.documentID
                friends.append(email)
            }
            
            completion(.success(friends))
        }
    }
    
    private func addFriend(email: String, partnerEmail: String) {
        store.collection("users").document(email).collection("friends").document(partnerEmail).setData(["email": partnerEmail]) { (error) in
            guard error == nil else {return}
        }
    }
    
    public func deleteFriend(email: String, partnerEmail: String) {
        store.collection("users").document(email).collection("friends").document(partnerEmail).delete { (err) in
            guard err == nil else {return}
        }
    }
    
    
    
    // About Conversations functions
    //   - getAllConversations
    //   - conversationExists
    //   - createNewConversation
    //   - getCurrentUserConversations
    //   - deleteConversation
    
    
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
            self.addFriend(email: email, partnerEmail: partnerEmail)
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
    
    //会話を削除
    public func deleteConversation(conversatonID: String) {
        store.collection("conversations").document(conversatonID).delete { (error) in
            guard error == nil else {
                print("error: ", error!)
                return
            }
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
                    guard let messageType = data["messageType"] as? String ?? "" else {return}
                    let sender = Sender(senderId: data["sender"] as? String ?? "",
                                        displayName: data["dispName"] as? String ?? "")
                    if messageType == "text" {
                        let message = Message(sender: sender,
                                              messageId: snap.documentID,
                                              sentDate: data["date"] as? Date ?? Date(),
                                              kind: .text(data["content"] as? String ?? ""))
                        messages.append(message)
                    } else if messageType == "photo" {
                        let urlString = data["imageURL"] as? String ?? ""
                        let url = URL(string: urlString)
                        let imageView = UIImageView()
                        imageView.sd_setImage(with: url, completed: nil)
                        let image = imageView.image ?? UIImage()
                        let message = Message(sender: sender,
                                              messageId: snap.documentID,
                                              sentDate: data["date"] as? Date ?? Date(),
                                              kind: .photo(Media(image: image, url: url,
                                                                 placeholderImage: image,
                                                                 size: CGSize(width: 150, height: 150))))
                        messages.append(message)
                    }
                }
                completion(.success(messages))
            }
    }
    
    public func insertMessage(id: String, message: Message, content: String) {
        switch message.kind {
        case .text(let text):
            let data: [String: Any] = [
                "sender": message.sender.senderId,
                "dispName": message.sender.displayName,
                "date": message.sentDate,
                "content": text,
                "messageType": "text"
            ]
            self.store.collection("conversations").document(id).collection("messages").document(message.messageId).setData(data) { (err) in
                guard err == nil else {return}
            }
        case .attributedText(_), .video(_), .audio(_), .contact(_), .location(_), .emoji(_), .custom(_):
            break
        case .photo(let media):
            let data: [String: Any] = [
                "sender": message.sender.senderId,
                "dispName": message.sender.displayName,
                "date": message.sentDate,
                "content": content,
                "imageURL": media.url?.absoluteString ?? "",
                "messageType": "photo"
            ]
            self.store.collection("conversations").document(id).collection("messages").document(message.messageId).setData(data) { (err) in
                guard err == nil else {return}
            }
            break
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


