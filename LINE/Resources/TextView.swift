import UIKit

class TextView: UITextView {
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var fontSize: CGFloat? {
        didSet {
            placeholderLabel.font = .systemFont(ofSize: fontSize ?? 0)
        }
    }
    
    var placeholderAlpha: CGFloat? {
        didSet {
            placeholderLabel.alpha = placeholderAlpha ?? 0
        }
    }
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "今なにしてる？"
        label.textColor = .lightGray
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeholderLabel)
        placeholderLabel.font = .systemFont(ofSize: 18)
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        placeholderLabel.frame = CGRect(x: 5, y: 10, width: width, height: 18)
    }
    
}
