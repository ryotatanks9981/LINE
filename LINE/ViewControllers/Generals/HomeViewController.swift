import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let userInfoView = UserInfoView()
    private let groupeView = GroupeListView()
    private let friendView = FriendsListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBarItems()
        
        // add sub views
        view.addSubview(scrollView)
        scrollView.addSubview(userInfoView)
        scrollView.addSubview(groupeView)
        scrollView.addSubview(friendView)
        
        userInfoView.backgroundColor = view.backgroundColor
        userInfoView.isUserInteractionEnabled = true
        userInfoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUserDetail)))
        
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
        
        groupeView.frame = CGRect(x: 0, y: userInfoView.bottom, width: view.width, height: 380)
        friendView.frame = CGRect(x: 0, y: groupeView.bottom, width: view.width, height: 30)
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
