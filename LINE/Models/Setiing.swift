import Firebase

enum SettingType {
    case profile
    case logout
}

struct Setting {
    let modelType: SettingType
    let title: String
    
    public func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            return
        }
    }
}
