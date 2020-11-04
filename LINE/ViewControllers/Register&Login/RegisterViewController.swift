import UIKit
import FirebaseAuth
import Firebase
import PKHUD

class RegisterViewController: ViewController {
    //components
    /// imageView, usernameTF, emailTF, passwordTF, registerBT
    private let profileImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "person"))
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.tintColor = .black
        view.layer.masksToBounds = true
        return view
    }()
    private let usernameTF: TextField = {
        let tf = TextField()
        tf.placeholder = "ユーザー名"
        tf.layer.borderWidth = 0
        return tf
    }()
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
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("新規登録", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfDelegate()
        setupViews()
        usernameTF.becomeFirstResponder()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = view.width/5
        let viewTop: CGFloat = navigationController?.navigationBar.top ?? 0
        profileImageView.frame = CGRect(x: size/2.5, y: viewTop+view.width/5,
                                        width: size, height: size)
        profileImageView.layer.cornerRadius = size/2
        usernameTF.frame = CGRect(x: profileImageView.right+10, y: profileImageView.bottom-40,
                                  width: size * 3, height: 40)
        emailTF.frame = CGRect(x: (view.width-view.width/1.5)/2, y: profileImageView.bottom+view.width/4,
                               width: view.width/1.5, height: 40)
        passwordTF.frame = CGRect(x: (view.width-view.width/1.5)/2, y: emailTF.bottom+10,
                                  width: view.width/1.5, height: 40)
        registerButton.frame = CGRect(x: (view.width-view.width/1.5)/2, y: passwordTF.bottom+10,
                                      width: view.width/1.5, height: 40)
        
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: 38, width: size*3, height: 2)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        usernameTF.layer.addSublayer(bottomBorder)
    }
    
    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(usernameTF)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(registerButton)
        title = "新規登録"
    }
    private func tfDelegate() {
        usernameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    private func camera() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    private func lib() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    private func showRegisterAlert(message: String = "すでに使用されているメールアドレスです") {
        let alertVC = UIAlertController(title: "登録エラー",
                                        message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "了解", style: .default))
        present(alertVC, animated: true)
    }
    
    // objc functions
    @objc private func selectProfileImage() {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "カメラで撮影", style: .default) { _ in
            self.camera()
        }
        let lib = UIAlertAction(title: "写真を選択", style: .default) { _ in
            self.lib()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        actionsheet.addAction(camera)
        actionsheet.addAction(lib)
        actionsheet.addAction(cancel)
        present(actionsheet, animated: true)
    }
    
    @objc private func register() {
        HUD.show(.progress)
        guard let username = usernameTF.text, !username.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty, password.count >= 6 else {
            HUD.hide()
            showRegisterAlert(message: "項目が条件を満たしていません")
            return
        }
        StoreManager.shared.userExists(email: email) { (exists) in
            if !exists {
                // ユーザー情報をfirestoreに保存
                Auth.auth().createUser(withEmail: email, password: password) { (_, err) in
                    guard err == nil else {
                        HUD.hide()
                        return
                    }
                    
                    guard let image = self.profileImageView.image?.pngData() else {return}
                    let fileName = "\(email)_profile_imaege.png"
                    StorageManager.shared.uploadProfileImage(uploadData: image, fileName: fileName) { (result) in
                        switch result {
                        case .success(let url):
                            let user = User(doc: [
                                "username": username,
                                "createdAt": Timestamp(),
                                "profileImageUrl": url
                            ], email: email)
                            StoreManager.shared.insertUser(user: user)
                            HUD.hide()
                            self.dismiss(animated: true)
                            break
                        case .failure(let err):
                            print("error: \(err)")
                            break
                        }
                    }
                }
            } else {
                self.showRegisterAlert()
                HUD.hide()
                return
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            register()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        profileImageView.image = image.withRenderingMode(.alwaysOriginal)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
