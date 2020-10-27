import UIKit
import SDWebImage

class UserDetailViewController: UIViewController {
    
    public var user: User? {
        didSet {
            usernameLabel.text = user?.username
            guard let url = user?.profileImageUrl else {return}
            imageView.sd_setImage(with: URL(string: url), completed: nil)
//            guard let backImageView = user.backImageView else {return}
        }
    }

    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "userBackgroundImage")
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0.1
        return view
    }()
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
        label.font = .systemFont(ofSize: 30)
        label.text = "username"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private let statusMessageButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("ステータスメッセージ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapStatusMessage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(backView)
        view.addSubview(imageView)
        view.addSubview(usernameLabel)
        view.addSubview(statusMessageButton)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        createNavBarItems()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        backView.frame = backgroundImageView.bounds
        
        let size = view.width/4
        imageView.frame = CGRect(x: (view.width-size)/2, y: view.height/2+size/2, width: size, height: size)
        imageView.layer.cornerRadius = size/2
        imageView.clipsToBounds = true
        
        usernameLabel.frame = CGRect(x: 0, y: imageView.bottom+3, width: view.width, height: 30)
        statusMessageButton.frame = CGRect(x: 0, y: usernameLabel.bottom+3, width: view.width, height: 25)
    }
    
    private func createNavBarItems() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapLeftButton))
        leftButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
    }
    
    // objc func
    @objc private func didTapLeftButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapStatusMessage() {
        let vc = StatusMessageViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
