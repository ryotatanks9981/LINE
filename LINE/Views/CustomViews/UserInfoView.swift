import UIKit
import SDWebImage

class UserInfoView: UIView {
    
    var user: User? {
        didSet {
            guard let url = user?.profileImageUrl else {return}
            imageView.sd_setImage(with: URL(string: url), completed: nil)
            usernameLabel.text = user?.username
        }
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.image = UIImage(systemName: "person")
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(usernameLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height/1.5
        imageView.frame = CGRect(x: 10, y: (height-size)/2, width: size, height: size)
        imageView.layer.cornerRadius = size/2
        imageView.clipsToBounds = true
        
        usernameLabel.frame = CGRect(x: imageView.right+10, y: (height-21)/2, width: width/2, height: 21)
    }
    
}
