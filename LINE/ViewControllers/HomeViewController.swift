import UIKit

class HomeViewController: UIViewController {
    
    private let userInfoView = UserInfoView()
    private let groupeView = GroupeListView()
    private let friendView = FriendsListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBarItems()
        
        showLoginAndRegister()
        
        // add sub views
        view.addSubview(userInfoView)
        view.addSubview(groupeView)
        view.addSubview(friendView)
        
        userInfoView.backgroundColor = view.backgroundColor
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewTop: CGFloat = navigationController?.navigationBar.bottom ?? 0
        userInfoView.frame = CGRect(x: 0, y: viewTop, width: view.width, height: 70)
        
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
    
    private func showLoginAndRegister() {
        let vc = RegisterAndLoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    
    // objc functions
    @objc private func didTapLeftButton() {
        print("didTapLeftButton")
    }
    
    @objc private func didTapRightButton() {
        print("didTapRightButton")
    }
}
