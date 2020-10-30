import UIKit
import SDWebImage
import Firebase

class TalkTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            guard let url = user?.profileImageUrl else {return}
            profileImageView.sd_setImage(with: URL(string: url), completed: nil)
            usernameLabel.text = user?.username
        }
    }
    
    var conversation: Conversation? {
        didSet {
            guard let email = Auth.auth().currentUser?.email else {return}
            conversation?.members.forEach({ (userEmail) in
                if email != userEmail {
                    StoreManager.shared.getCurrentUser(with: userEmail) { (result) in
                        switch result {
                        case .success(let user):
                            self.latestMessageLabel.text = self.conversation?.latestMessage
                            self.dateLabel.text = self.dateFormatter(date: self.conversation?.update ?? Timestamp())
                            self.user = user
                            break
                        case .failure(_): break
                        }
                    }
                }
            })
        }
    }
    
    
    static let id = "TalkTableViewCell"
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.image = UIImage(systemName: "person")
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "username"
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let latestMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "最後のメッセージ"
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "12:00"
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(latestMessageLabel)
        addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.height/1.5
        profileImageView.frame = CGRect(x: contentView.left+10, y: (contentView.height-size)/2, width: size, height: size)
        profileImageView.layer.cornerRadius = size/2
        profileImageView.clipsToBounds = true
        
        usernameLabel.frame = CGRect(x: profileImageView.right+10, y: profileImageView.top+5, width: contentView.width/2, height: 21)
        latestMessageLabel.frame = CGRect(x: profileImageView.right+10, y: usernameLabel.bottom+2, width: contentView.width/2, height: 16)
        dateLabel.frame = CGRect(x: contentView.right-contentView.width/3-10,
                                 y: usernameLabel.bottom+2,
                                 width: contentView.width/3,
                                 height: 14)
    }
    
    public func dateFormatter(date: Timestamp) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date.dateValue())
    }
}
