import UIKit

class BaseTabViewController: UITabBarController {

    enum IndexName: Int {
        case home, talk, timeline, news
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers?.enumerated().forEach({ (index, controller) in
            if let name = IndexName.init(rawValue: index) {
                switch name {
                case .home:
                    controller.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
                    controller.tabBarItem.image = UIImage(systemName: "house.fill")
                    break
                case .talk:
                    controller.tabBarItem.selectedImage = UIImage(systemName: "message.fill")
                    controller.tabBarItem.image = UIImage(systemName: "message.fill")
                    break
                case .timeline:
                    controller.tabBarItem.selectedImage = UIImage(systemName: "stopwatch.fill")
                    controller.tabBarItem.image = UIImage(systemName: "stopwatch.fill")
                    break
                case .news:
                    controller.tabBarItem.selectedImage = UIImage(systemName: "doc.plaintext.fill")
                    controller.tabBarItem.image = UIImage(systemName: "doc.plaintext.fill")
                    break
                }
            }
        })
    }
}
