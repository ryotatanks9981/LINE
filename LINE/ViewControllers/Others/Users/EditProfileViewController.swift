import UIKit
import SDWebImage
import FirebaseAuth

class EditProfileViewController: ViewController {
    
    private var user: User? {
        didSet {
            guard let user = user else {return}
            usernameTextField.text = user.username
            statusMessageTextField.text = user.statusMessage
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl)!, completed: nil)
            
            guard let headerURL = user.backImageViewUrl else {
                headerImageView.image = UIImage(named: "userBackgroundImage")
                return
            }
            headerImageView.sd_setImage(with: URL(string: headerURL), completed: nil)
        }
    }

    private let headerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .gray
        view.image = UIImage(named: "userBackgroundImage")
        view.isUserInteractionEnabled = true
        return view
    }()
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .gray
        view.isUserInteractionEnabled = true
        return view
    }()
    private let usernameTextField: TextField = {
        let field = TextField()
        return field
    }()
    private let statusMessageTextField: TextField = {
        let field = TextField()
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerImageView)
        view.addSubview(profileImageView)
        view.addSubview(usernameTextField)
        view.addSubview(statusMessageTextField)
        
        headerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(didTapHeaderImageView)))
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(didTapProfileImageView)))
        
        createNavBarItems()
        getCurrentUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewTop: CGFloat = navigationController?.navigationBar.bottom ?? 0
        let size = view.width/5
        headerImageView.frame = .init(x: 0, y: viewTop, width: view.width, height: view.width/3)
        profileImageView.frame = .init(x: (view.width-size)/2, y: headerImageView.bottom-size/2,
                                       width: size, height: size)
        profileImageView.layer.cornerRadius = size/2
        profileImageView.clipsToBounds = true
        
        usernameTextField.frame = .init(x: (view.width-size*3)/2, y: profileImageView.bottom+30,
                                        width: size*3, height: 40)
        statusMessageTextField.frame = .init(x: (view.width-size*3)/2, y: usernameTextField.bottom+30,
                                        width: size*3, height: 40)
        
    }
    
    private func getCurrentUser() {
        guard let email = Auth.auth().currentUser?.email else { return }
        StoreManager.shared.getCurrentUser(with: email) { (re) in
            switch re {
            case .success(let user):
                self.user = user
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func createNavBarItems() {
        let rightButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(save))
        rightButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightButton
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
    
    // objc funcs
    @objc private func save() {
        
        guard let user = user, let email = Auth.auth().currentUser?.email else {return}
        
        guard let uploadData = profileImageView.image?.pngData() else {return}
        let fileName = "\(email)_profile_imaege.png"
        StorageManager.shared.uploadProfileImage(uploadData: uploadData, fileName: fileName) { (result) in
            switch result {
            case .success(let urlString):
                guard let username = self.usernameTextField.text, let statusMessage = self.statusMessageTextField.text else {return}
                let doc: [String: Any] = [
                    "username": username,
                    "createdAt": user.createdAt,
                    "profileImageUrl": urlString,
                    "backImageViewUrl": urlString,
                    "statusMessage": statusMessage,
                ]
                let updateUser = User(doc: doc, email: email)
                
                StoreManager.shared.insertUser(user: updateUser)
                self.dismiss(animated: true, completion: nil)
                break
            case .failure(_):
                break
            }
        }
        
    }
    
    private func showActionSheet(title: String) {
        let actionsheet = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
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
    
    @objc private func didTapHeaderImageView() {
        showActionSheet(title: "ヘッダー画像を設定")
    }
    
    @objc private func didTapProfileImageView() {
        showActionSheet(title: "プロフィール画像の設定")
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        profileImageView.image = image
        headerImageView.image = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
