import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    private var friends = [User]()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let userInfoView = UserInfoView()
    private let friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "友だち"
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private let table: UITableView = {
        let view = UITableView()
        view.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
        view.tableFooterView = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBarItems()
        
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        // add sub views
        view.addSubview(scrollView)
        scrollView.addSubview(userInfoView)
        scrollView.addSubview(friendsLabel)
        scrollView.addSubview(table)
        
        userInfoView.backgroundColor = view.backgroundColor
        userInfoView.isUserInteractionEnabled = true
        userInfoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUserDetail)))
        
        fetchFriend()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoginAndRegister(animated: false)
        
        fetchMyInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        userInfoView.frame = CGRect(x: 0, y: 0, width: view.width, height: 70)
        friendsLabel.frame = CGRect(x: 10, y: userInfoView.bottom, width: view.width, height: 30)
        table.frame = CGRect(x: 0, y: friendsLabel.bottom, width: scrollView.width, height: scrollView.height-userInfoView.height)
        
    }
    
    private func createNavBarItems() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapLeftButton))
        leftButton.tintColor = .white
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"),
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapRightButton))
        rightButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func fetchFriend() {
        guard let email = Auth.auth().currentUser?.email else {return}
        StoreManager.shared.fetchFriends(email: email) { (re) in
            switch re {
            case .success(let friends):
                friends.forEach { (email) in
                    StoreManager.shared.getCurrentUser(with: email) { (re) in
                        switch re {
                        case .success(let user):
                            self.friends.append(user)
                            self.table.reloadData()
                            break
                        case .failure(_):
                            break
                        }
                    }
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func showLoginAndRegister(animated: Bool) {
        if Auth.auth().currentUser == nil {
            let vc = RegisterAndLoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: animated)
        }
    }
    
    private func fetchMyInfo() {
        guard let email = Auth.auth().currentUser?.email else { return }
        StoreManager.shared.getCurrentUser(with: email) { (result) in
            switch result {
            case .success(let user):
                self.userInfoView.user = user
                break
            case .failure(let error):
                print("error: ", error)
                break
            }
        }
    }
    
    
    // objc functions
    @objc private func didTapLeftButton() {
        let vc = SettingViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc private func didTapRightButton() {
        let vc = AddConversationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showUserDetail() {
        let vc = UserDetailViewController()
        vc.user = userInfoView.user
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id, for: indexPath) as! UserTableViewCell
        let friend = friends[indexPath.row]
        cell.user = friend
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UserDetailViewController()
        vc.user = friends[indexPath.row]
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let email = Auth.auth().currentUser?.email,
              let conversationID = UserDefaults.standard.value(forKey: "conversationID") as? String ?? "" else {return}
        let friend = friends[indexPath.row]
        StoreManager.shared.deleteFriend(email: email, partnerEmail: friend.email)
        StoreManager.shared.deleteConversation(conversatonID: conversationID)
        friends.remove(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
}
