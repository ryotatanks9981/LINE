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
        
        setupInputButton()
        
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { (_) in
            self.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionsheet = UIAlertController(title: "メディアの選択", message: "", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "カメラで撮影", style: .default, handler: { (_) in
            self.camera()
        }))
        actionsheet.addAction(UIAlertAction(title: "写真を選択", style: .default, handler: { (_) in
            self.photoLibrary()
        }))
        actionsheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(actionsheet, animated: true, completion: nil)
    }
    
    private func camera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.isEditing = true
        self.present(picker, animated: true)
    }
    
    private func photoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.isEditing = true
        self.present(picker, animated: true)
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

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage, let uploadData = image.pngData() else {return}
        let fileName = UUID().uuidString
        StorageManager.shared.uploadMessagePhoto(uploadData: uploadData, fileName: fileName) { (re) in
            switch re {
            case .success(let urlString):
                let uuid = UUID().uuidString
                guard let url = URL(string: urlString) else {
                    print("失敗しました")
                    return
                }
                let message = Message(sender: self.sender,
                                      messageId: uuid,
                                      sentDate: Timestamp().dateValue(),
                                      kind: .photo(Media(image: image, url: url, placeholderImage: image, size: CGSize(width: 150, height: 150))))
                self.messages.append(message)
                guard let id = self.conversation?.id else {return}
                StoreManager.shared.insertMessage(id: id, message: message, content: "画像を送信しました")
                self.messagesCollectionView.reloadData()
                self.dismiss(animated: true, completion: nil)
                break
            case .failure(let error):
                print("erorr:", error)
                break
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
