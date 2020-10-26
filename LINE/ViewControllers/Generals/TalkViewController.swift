import UIKit
import FirebaseAuth

class TalkViewController: UIViewController {

    private var conversations = [Conversation]()
    
    private let table: UITableView = {
        let view = UITableView()
        view.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBarItems()
        
        getMyConversations()
        
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id, for: indexPath)
        return cell
    }
    
    
}
