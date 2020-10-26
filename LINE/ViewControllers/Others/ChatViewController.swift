import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

    var conversation: Conversation?
    
    private var messages = [Message]()
    
    var sender: Sender?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        createNavBarItems()
        
        fetchUser()
        getAllMessages()
        
    }
    
    private func getAllMessages() {
        guard let conversation = conversation else {return}
        StoreManager.shared.fetchAllMessages(conversation: conversation) { (re) in
            switch re {
            case .success(let messages):
                self.messages = messages
                self.messagesCollectionView.reloadData()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func fetchUser() {
        guard let email = Auth.auth().currentUser?.email else {return}
        StoreManager.shared.getCurrentUser(with: email) { (re) in
            switch re {
            case .success(let user):
                self.sender = Sender(senderId: user.email, displayName: user.username)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func createNavBarItems() {
        navigationItem.hidesBackButton = true
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .done,
                                         target: self,
                                         action: #selector(back))
        leftButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
    }
    
    
    //objc functions
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        guard let sender = sender else {return Sender(senderId: "", displayName: "")}
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let uuid = UUID().uuidString
        guard let sender = sender else {return}
        let message = Message(sender: sender, messageId: uuid, sentDate: Timestamp().dateValue(), kind: .text(text))
        messages.append(message)
        messagesCollectionView.reloadData()
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToBottom(animated: true)
        
        guard let id = conversation?.id else {return}
        StoreManager.shared.insertMessage(id: id, message: message, content: text)
    }
}
