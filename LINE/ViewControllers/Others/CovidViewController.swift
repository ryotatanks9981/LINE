import UIKit
import UIGradient
import SwiftyJSON

class CovidViewController: UIViewController {
    
    private let covidView = CovidView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = GradientLayer.oceanBlue
        view.addGradient(gradient)
        createNavBarItems()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        view.addSubview(covidView)
        covidView.layer.shadowOffset = .init(width: 10, height: 5)
        covidView.layer.shadowColor = UIColor.black.cgColor
        covidView.layer.shadowRadius = 15
        covidView.layer.shadowOpacity = 1
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        covidView.frame = CGRect(x: (view.width-view.width/1.5)/2, y: (view.height-view.height/2)/2,
                                 width: view.width/1.5, height: view.height/3)
        covidView.layer.cornerRadius = 15
        covidView.layer.borderWidth = 1
//        covidView.layer.borderColor = UIColor.clear.cgColor
        covidView.clipsToBounds = true
    }
    
    private func getData() {
        let headers = [
            "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
            "x-rapidapi-key": "f74142bb4emsh3a652272ef17a8ap13f675jsnca8a6b04ddb5"
        ]
        let urlString = "https://covid-19-data.p.rapidapi.com/country?format=json&name=Japan"
        let req = NSMutableURLRequest(url: URL(string: urlString)!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10)
        req.httpMethod = "GET"
        req.allHTTPHeaderFields = headers
        URLSession.shared.dataTask(with: req as URLRequest) { (data, _, _) in
            let json = try! JSON(data: data!)
            let docData: [String: Any] = [
                "country": json[0]["country"].stringValue,
                "confirmed": json[0]["confirmed"].stringValue,
                "critical": json[0]["critical"].stringValue,
                "deaths": json[0]["deaths"].stringValue,
            ]
            self.covidView.covid = Covid(data: docData)
        }.resume()
    }
    
    private func createNavBarItems() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapLeftButton))
        leftButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
    }
    
    // objc func
    @objc private func didTapLeftButton() {
        dismiss(animated: true)
    }
}
