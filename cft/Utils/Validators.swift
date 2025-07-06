import Foundation

struct Validators {
    static func isValidName(_ name: String) -> Bool {
        return name.count >= 2
    }

    static func isValidPassword(_ password: String) -> Bool {
        let hasUpper = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        return password.count >= 6 && hasUpper && hasDigit
    }
} 