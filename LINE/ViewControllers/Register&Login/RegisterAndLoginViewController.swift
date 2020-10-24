import UIKit

class RegisterAndLoginViewController: UIViewController {

    private let imageView = UIImageView(image: UIImage(named: "logo"))
    private let welcomeLabel: UILabel = {
        let l = UILabel()
        l.text = "LINEへようこそ"
        l.textColor = .black
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 30, weight: .bold)
        return l
    }()
    private let descriptLabel: UILabel = {
        let l = UILabel()
        l.text = "無料のメールや音声・ビデオ通話を楽しもう！"
        l.textColor = .lightGray
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 14, weight: .bold)
        return l
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("ログイン", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("新規登録", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutSubViews()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(imageView)
        view.addSubview(welcomeLabel)
        view.addSubview(descriptLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    private func layoutSubViews() {
        let size = view.width/3.5
        let viewTop: CGFloat = navigationController?.navigationBar.bottom ?? 0
        imageView.frame = CGRect(x: (view.width-size)/2, y: viewTop + view.width/3, width: size, height: size)
        welcomeLabel.frame = CGRect(x: (view.width-view.width/1.7)/2, y: imageView.bottom+30,
                                    width: view.width/1.7, height: 30)
        descriptLabel.frame = CGRect(x: (view.width-view.width/1.3)/2, y: welcomeLabel.bottom+3,
                                    width: view.width/1.3, height: 30)
        loginButton.frame = CGRect(x: (view.width-view.width/1.5)/2, y: descriptLabel.bottom+view.width/2,
                                   width: view.width/1.5, height: 40)
        registerButton.frame = CGRect(x: (view.width-view.width/1.5)/2, y: loginButton.bottom+10,
                                   width: view.width/1.5, height: 40)
    }
    
    // objc func
    @objc private func didTapLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
