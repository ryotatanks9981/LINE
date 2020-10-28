import UIKit
import Firebase

class AddTLPostViewController: UIViewController {

    private let textView: TextView = {
        let view = TextView()
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textView)
        textView.delegate = self
        
        createNavBarItems()
        textView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    private func createNavBarItems() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                         style: .done,
                                         target: self,
                                         action: #selector(back))
        leftButton.tintColor = .black
        let rightButton = UIBarButtonItem(title: "投稿",
                                          style: .done,
                                          target: self,
                                          action: #selector(post))
        rightButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    //objc func
    @objc private func post() {
        guard let email = Auth.auth().currentUser?.email, let text = textView.text else {return}
        let doc: [String: Any] = [
            "owner": email,
            "content": text,
            "createdAt": Timestamp()
        ]
        let post = Post(doc: doc)
        StoreManager.shared.insertPost(post: post)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func back() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddTLPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
            self.textView.placeholderAlpha = 1
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.textView.placeholderAlpha = 0
        }
    }
}
