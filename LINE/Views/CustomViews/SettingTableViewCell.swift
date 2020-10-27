import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let id = "SettingTableViewCell"
    
    var setting: Setting? {
        didSet {
            
            textLabel?.text = setting?.title
            
            switch setting?.modelType {
            case .logout:
                textLabel?.textColor = .red
                break
            case .profile:
                break
            case .none:
                break
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
