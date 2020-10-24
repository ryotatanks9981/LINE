import UIKit

class LoginViewController: ViewController {

    private let emailTF: TextField = {
        let tf = TextField()
        tf.placeholder = "メールアドレス"
        return tf
    }()
    private let passwordTF: TextField = {
        let tf = TextField()
        tf.placeholder = "パスワード(6文字以上)"
        return tf
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("ログイン", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfDelegate()
        setupViews()
        emailTF.becomeFirstResponder()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewTop: CGFloat = navigationController?.navigationBar.top ?? 0
        emailTF.frame = CGRect(x: (view.width-view.width/1.5)/2, y: viewTop+view.width/2,
                               width: view.width/1.5, height: 40)
        passwordTF.frame = CGRect(x: (view.width-view.width/1.5)/2, y: emailTF.bottom+10,
                                  width: view.width/1.5, height: 40)
        loginButton.frame = CGRect(x: (view.width-view.width/1.5)/2, y: passwordTF.bottom+10,
                                      width: view.width/1.5, height: 40)
    }
    
    
    private func setupViews() {
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
        title = "ログイン"
    }
    private func tfDelegate() {
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    // objc functions
    @objc private func login() {
        dismiss(animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}
