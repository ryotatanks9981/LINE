import UIKit
import SDWebImage

protocol UserTableViewCellDelegate: class {
    func showDetail(user: User)
}

class UserTableViewCell: UITableViewCell {

    public var delegate: UserTableViewCellDelegate?
    
    var user: User? {
        didSet {
            guard let url = user?.profileImageUrl else {return}
            profileImageView.sd_setImage(with: URL(string: url), completed: nil)
            usernameLabel.text = user?.username
        }
    }
    
    static let id = "UserTableViewCell"
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        label.text = "username"
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetail)))
        profileImageView.isUserInteractionEnabled = true
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
        
        usernameLabel.frame = CGRect(x: profileImageView.right+10, y: (contentView.height-21)/2, width: contentView.width/2, height: 21)
    }
    
    @objc private func showDetail() {
        guard let user = user else {return}
        delegate?.showDetail(user: user)
    }
}
