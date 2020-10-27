import UIKit

class StatusMessageViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "userBackgroundImage")
        view.contentMode = .scaleAspectFill
        view.addBlur(style: .systemUltraThinMaterialDark)
        return view
    }()
    
    private let statusMessageTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isSelectable = false
        view.textColor = .white
        view.textAlignment = .center
        view.backgroundColor = .clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        view.addSubview(backgroundImageView)
        view.addSubview(statusMessageTextView)
        
        createNavBarItems()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundImageView.frame = view.bounds
        statusMessageTextView.frame = CGRect(x: 0, y: view.height/3,
                                             width: view.width, height: view.width/2)
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
}
