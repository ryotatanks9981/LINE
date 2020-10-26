import UIKit
import FirebaseAuth

class AddConversationViewController: ViewController {
    
    private var users = [User]()

    private let tableView: UITableView = {
        let view = UITableView()
        view.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAllUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func fetchAllUserInfo() {
        guard let email = Auth.auth().currentUser?.email else {return}
        StoreManager.shared.getAllUser(email: email) { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
                break
            case.failure(let err):
                print(err)
                return
            }
        }
    }
}

extension AddConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id, for: indexPath) as! UserTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let email = Auth.auth().currentUser?.email else {return}
        
        let user = users[indexPath.row]
        let conversationID = "\(email)_\(user.email)"
        StoreManager.shared.conversationExists(conversationID: conversationID) { (exists) in
            if !exists {
                self.showActionSheet(email: email, user: user)
            } else {
                let vc = ChatViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    private func showActionSheet(email: String, user: User) {
        let actionSheet = UIAlertController(title: user.username, message: nil, preferredStyle: .actionSheet)
        let conversation = UIAlertAction(title: "話す", style: .default) { (_) in
            StoreManager.shared.createNewConversation(email: email, partnerEmail: user.email)
            let vc = ChatViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        actionSheet.addAction(conversation)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}
