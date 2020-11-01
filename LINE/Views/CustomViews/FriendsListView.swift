import UIKit
import SDWebImage

protocol FriendsListViewDelegate: class {
    func deleteFriend(index: Int)
}

class FriendsListView: UIView {
    
    var friends: [User]?
    
    public var delegate: FriendsListViewDelegate?
    
    private let uiView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "友だち"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
        tableView.isScrollEnabled = false
        tableView.isHidden = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(uiView)
        uiView.addSubview(imageView)
        uiView.addSubview(titleLabel)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = 20/1.3
        imageView.frame = CGRect(x: 20, y: 5, width: size, height: size)
        titleLabel.frame = CGRect(x: imageView.right+30, y: 5, width: width/1.5, height: size)
        tableView.frame = CGRect(x: 0, y: imageView.bottom+5, width: width, height: height-imageView.height)
    }
}


extension FriendsListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id, for: indexPath) as! UserTableViewCell
        cell.user = friends?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.deleteFriend(index: indexPath.row)
    }
}
