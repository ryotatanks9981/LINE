import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBarItems()
    }

    private func createNavBarItems() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapLeftButton))
        leftButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
    }
    
    // objc functions
    @objc private func didTapLeftButton() {
        print("didTapLeftButton")
    }
    
}
