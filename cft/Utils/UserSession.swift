import Foundation

final class UserSession {
    static let shared = UserSession()
    private let nameKey = "user_name"
    private let isRegisteredKey = "is_registered"

    var userName: String? {
        get { UserDefaults.standard.string(forKey: nameKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: nameKey) }
    }

    var isRegistered: Bool {
        get { UserDefaults.standard.bool(forKey: isRegisteredKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: isRegisteredKey) }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: nameKey)
        UserDefaults.standard.setValue(false, forKey: isRegisteredKey)
    }
} 