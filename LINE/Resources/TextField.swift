import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        rightViewMode = .always
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
