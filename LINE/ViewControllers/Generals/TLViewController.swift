import UIKit

class TLViewController: UIViewController {

    private var posts = [Post]()
    
    private let table: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView()
        view.register(TLTableViewCell.self, forCellReuseIdentifier: TLTableViewCell.id)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        
        StoreManager.shared.getAllPosts { (result) in
            switch result {
            case .success(let posts):
                self.posts = posts
                self.table.reloadData()
                break
            case .failure(_):
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.frame = view.bounds
        table.separatorStyle = .none
        table.rowHeight = 250
        
        createNavBarItems()
    }
    
    private func createNavBarItems() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                          style: .done,
                                          target: self,
                                          action: #selector(addContent))
        rightButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightButton
    }
    
    //objc funcs
    @objc private func addContent() {
        let vc = AddTLPostViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

extension TLViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TLTableViewCell.id, for: indexPath) as! TLTableViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
