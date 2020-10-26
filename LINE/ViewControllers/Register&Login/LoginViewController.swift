import UIKit
import FirebaseAuth
import PKHUD

class LoginViewController: ViewController {

    private let emailTF: TextField = {
        let tf = TextField()
        tf.placeholder = "メールアドレス"
        return tf
    }()
    private let passwordTF: TextField = {
        let tf = TextField()
        tf.placeholder = "パスワード(6文字以上)"
        tf.isSecureTextEntry = true
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
        HUD.show(.progress)
        guard let email = emailTF.text, let password = passwordTF.text else {
            HUD.hide()
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (_, err) in
            guard err == nil else {
                HUD.hide()
                return
            }
            HUD.hide()
            self.dismiss(animated: true)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            login()
        }
        
        return true
    }
}
