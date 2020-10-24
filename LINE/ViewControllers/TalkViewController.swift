import UIKit

class TalkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBarItems()
    }

    private func createNavBarItems() {
        let leftButton = UIBarButtonItem(title: "編集",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapLeftButton))
        leftButton.tintColor = .white
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"),
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapRightButton))
        rightButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    // objc functions
    @objc private func didTapLeftButton() {
        print("didTapLeftButton")
    }
    
    @objc private func didTapRightButton() {
        print("didTapRightButton")
    }
}
