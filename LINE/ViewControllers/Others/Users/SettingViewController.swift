import UIKit
import FirebaseAuth

class SettingViewController: ViewController {
    
    public var models: [Setting] = [
        Setting(modelType: .profile, title: "プロフィール"),
        Setting(modelType: .logout, title: "ログアウト")
    ]
    
    private let scroll = UIScrollView()
    
    private let table: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scroll)
        scroll.addSubview(table)
        table.delegate = self
        table.dataSource = self
        navigationItem.leftBarButtonItem = nil
        createNavBarItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewTop: CGFloat = navigationController?.navigationBar.bottom ?? 0
        scroll.frame = view.bounds
        table.frame = CGRect(x: 0, y: viewTop, width: scroll.width, height: scroll.height)
    }
    
    private func createNavBarItems() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapLeftButton))
        leftButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftButton
        navigationController?.navigationBar.barTintColor = UIColor(red: 32, green: 47, blue: 85, alpha: 1)
    }
    
    //objc func
    @objc private func didTapLeftButton() {
        dismiss(animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setting = models[indexPath.row]
        
        switch setting.modelType {
        case .logout:
            alert {
                setting.logout()
                self.dismiss(animated: false)
            }
            break
        case .profile:
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    func alert(completion: @escaping ()->Void) {
        let alert = UIAlertController(title: "", message: "ログアウトしてもよろしいですか", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ログアウト", style: .default, handler: { (_) in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func showLoginAndRegister(animated: Bool) {
        if Auth.auth().currentUser == nil {
            let vc = RegisterAndLoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: animated)
        }
    }
}
