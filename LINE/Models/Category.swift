import UIKit

enum CategoryType {
    case covid19
    case news
}

struct Category {
    
    let title: String
    let categoryType: CategoryType
    let categoryImage: UIImage?
}
