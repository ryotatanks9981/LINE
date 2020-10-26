import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

    private var messages = [Message]()
    
    let selfSender = Sender(senderId: "123", displayName: "ddfs")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
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
        let message = Message(sender: selfSender, messageId: "23", sentDate: Date(), kind: .text(text))
        messages.append(message)
        messagesCollectionView.reloadData()
        inputBar.inputTextView.text = ""
    }
}
