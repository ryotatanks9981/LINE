import UIKit
import FirebaseAuth

class TalkViewController: UIViewController {

    private var conversations = [Conversation]()
    
    private let table: UITableView = {
        let view = UITableView()
        view.register(TalkTableViewCell.self, forCellReuseIdentifier: TalkTableViewCell.id)
        view.tableFooterView = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBarItems()
        
        getMyConversations()
        
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.frame = view.bounds
    }

    private func createNavBarItems() {
        let leftButton = UIBarButtonItem(title: "編集",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapLeftButton))
        leftButton.tintColor = .white
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"),
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapRightButton))
        rightButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func getMyConversations() {
        guard let email = Auth.auth().currentUser?.email else {return}
        StoreManager.shared.getCurrentUserConversations(email: email) { (result) in
            switch result {
            case .success(let conversations):
                self.conversations = conversations
                self.table.reloadData()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    // objc functions
    @objc private func didTapLeftButton() {
        print("didTapLeftButton")
    }
    
    @objc private func didTapRightButton() {
        print("didTapRightButton")
    }
}

extension TalkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TalkTableViewCell.id, for: indexPath) as! TalkTableViewCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let email = Auth.auth().currentUser?.email else {return}
        StoreManager.shared.getCurrentUser(with: email) { (re) in
            switch re {
            case .success(let user):
                let sender = Sender(senderId: email, displayName: user.username)
                let vc = ChatViewController(sender: sender)
                vc.conversation = self.conversations[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .failure(_):
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let conversationID = conversations[indexPath.row].id
        print(conversationID)
        StoreManager.shared.conversationExists(conversationID: conversationID) { (exist) in
            if exist {
                StoreManager.shared.deleteConversation(conversatonID: conversationID)
                self.conversations.remove(at: indexPath.row)
                self.table.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
