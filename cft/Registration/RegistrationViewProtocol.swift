enum RegistrationField {
    case name
    case surname
    case birthDate
    case password
    case confirmPassword
}

protocol RegistrationViewProtocol: AnyObject {
    func showError(message: String, field: RegistrationField)
    func enableRegisterButton(_ enabled: Bool)
    func registrationSuccess()
} 