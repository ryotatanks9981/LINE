class Covid {
    
    let country: String
    let confirmed: String
    let critical: String
    let deaths: String
    
    init(data: [String: Any]) {
        country = data["country"] as? String ?? ""
        confirmed = data["confirmed"] as? String ?? ""
        critical = data["critical"] as? String ?? ""
        deaths = data["deaths"] as? String ?? ""
    }
}
