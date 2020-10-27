import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

    var conversation: Conversation?
    
    private var messages = [Message]()
    
    var partnerUser: User? {
        didSet {
            title = partnerUser?.username
        }
    }
    
    var sender: Sender
    
    init(sender: Sender) {
        self.sender = sender
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.scrollToBottom()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.sendButton.setTitle("送信", for: .normal)
        
        createNavBarItems()
        getAllMessages()
        
    }
    
    private func getAllMessages() {
        guard let conversation = conversation else {return}
        StoreManager.shared.fetchAllMessages(conversation: conversation) { (re) in
            switch re {
            case .success(let messages):
                self.messages = messages
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
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
        let message = Message(sender: sender, messageId: uuid, sentDate: Timestamp().dateValue(), kind: .text(text))
        messages.append(message)
        messagesCollectionView.reloadData()
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToBottom(animated: true)
        
        guard let id = conversation?.id else {return}
        StoreManager.shared.insertMessage(id: id, message: message, content: text)
    }
}
