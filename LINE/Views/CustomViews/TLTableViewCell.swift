import UIKit
import SDWebImage


class TLTableViewCell: UITableViewCell {

    static let id = "TLTableViewCell"
    
    public var post: Post? {
        didSet {
            guard let email = post?.owner else {return}
            StoreManager.shared.getCurrentUser(with: email) { (result) in
                switch result {
                case .success(let user):
                    self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl)!, completed: nil)
                    self.usernameLabel.text = user.username
                    break
                case .failure(_):
                    break
                }
            }
            postTextView.text = post?.content
        }
    }
    
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
    
    private let postTextView: UITextView = {
        let view = UITextView()
        view.isSelectable = false
        view.isEditable = false
        view.font = .systemFont(ofSize: 18)
        view.text = "Hello World"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(postTextView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.width/10
        profileImageView.frame = CGRect(x: 5, y: 5, width: size, height: size)
        profileImageView.layer.cornerRadius = size/2
        profileImageView.clipsToBounds = true
        
        usernameLabel.frame = CGRect(x: profileImageView.right+5, y: profileImageView.bottom-30,
                                     width: contentView.width-profileImageView.right-20, height: 20)
        postTextView.frame = CGRect(x: 5, y: profileImageView.bottom+10,
                                    width: contentView.width-10, height: contentView.height-size-20)
    }
}
