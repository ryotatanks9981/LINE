import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let id = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 3.0
        
        addSubview(imageView)
        addSubview(categoryNameLabel)
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        categoryNameLabel.frame = bounds
    }
    
    func setupContents(category: Category) {
        categoryNameLabel.text = category.title
        guard let image = category.categoryImage else {return}
        imageView.image = image
        if category.categoryType == .covid19 {
            categoryNameLabel.textColor = .white
        }
    }
    
}
