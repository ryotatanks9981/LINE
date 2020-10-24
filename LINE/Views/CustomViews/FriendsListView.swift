import UIKit

class FriendsListView: UIView {
    private let uiView = UIView()
    
    private let groupeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let groupeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "友だち"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.isHidden = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(uiView)
        uiView.addSubview(groupeImageView)
        uiView.addSubview(groupeTitleLabel)
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
        groupeImageView.frame = CGRect(x: 20, y: 5, width: size, height: size)
        groupeTitleLabel.frame = CGRect(x: groupeImageView.right+30, y: 5, width: width/1.5, height: size)
        tableView.frame = CGRect(x: 0, y: groupeImageView.bottom+5, width: width, height: height-groupeImageView.height)
    }
}


extension FriendsListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "groupe"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
