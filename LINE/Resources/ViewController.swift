import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .done,
                                         target: self,
                                         action: #selector(back))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

