import UIKit

class CovidView: UIView {
    
    public var covid: Covid? {
        didSet {
            DispatchQueue.main.async {
                self.countryLabel.text = self.covid?.country
                self.confirmedLabel.text = "総合発症者: \(self.covid?.confirmed ?? "")"
                self.criticalLabel.text = "重傷者: \(self.covid?.critical ?? "")"
                self.deathLabel.text = "死者: \(self.covid?.deaths ?? "")"
            }
        }
    }
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "日本"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    private let confirmedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "総合発症者"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    private let criticalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "重傷者"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    private let deathLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "死者"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(countryLabel)
        addSubview(confirmedLabel)
        addSubview(criticalLabel)
        addSubview(deathLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        countryLabel.frame = .init(x: 0, y: 20, width: width, height: 42)
        confirmedLabel.frame = .init(x: 0, y: countryLabel.bottom+40, width: width, height: 27)
        criticalLabel.frame = .init(x: 0, y: confirmedLabel.bottom+10, width: width, height: 27)
        deathLabel.frame = .init(x: 0, y: criticalLabel.bottom+10, width: width, height: 27)
    }
    
}
