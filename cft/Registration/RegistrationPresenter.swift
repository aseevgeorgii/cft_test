import Foundation

final class RegistrationPresenter {
    weak var view: RegistrationViewProtocol?
    private var name: String = ""
    private var surname: String = ""
    private var birthDate: Date?
    private var password: String = ""
    private var confirmPassword: String = ""
    private var passwordWasEdited = false
    private var confirmPasswordWasEdited = false

    init(view: RegistrationViewProtocol) {
        self.view = view
    }

    func updateName(_ name: String) {
        self.name = name
        validateAndShowError()
    }

    func updateSurname(_ surname: String) {
        self.surname = surname
        validateAndShowError()
    }

    func updateBirthDate(_ date: Date) {
        self.birthDate = date
        validateAndShowError()
    }

    func updatePassword(_ password: String) {
        self.password = password
        passwordWasEdited = true
        validateAndShowError()
    }

    func updateConfirmPassword(_ confirm: String) {
        self.confirmPassword = confirm
        confirmPasswordWasEdited = true
        validateAndShowError()
    }

    private func validateAndShowError() {
        var hasErrors = false
        
        if !surname.isEmpty {
            if !Validators.isValidName(surname) {
                view?.showError(message: "Фамилия слишком короткая", field: .surname)
                hasErrors = true
            } else {
                view?.showError(message: "", field: .surname)
            }
        } else {
            view?.showError(message: "", field: .surname)
        }
        
        if !name.isEmpty {
            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                view?.showError(message: "Имя не заполнено", field: .name)
                hasErrors = true
            } else {
                view?.showError(message: "", field: .name)
            }
        } else {
            view?.showError(message: "", field: .name)
        }
        
        if let birthDate = birthDate {
            if Calendar.current.isDateInToday(birthDate) {
                view?.showError(message: "Дата рождения не может совпадать с сегодняшним днём", field: .birthDate)
                hasErrors = true
            } else {
                view?.showError(message: "", field: .birthDate)
            }
        } else {
            view?.showError(message: "", field: .birthDate)
        }
        
        if !password.isEmpty {
            if !Validators.isValidPassword(password) {
                view?.showError(message: "Пароль должен содержать цифры и буквы верхнего регистра и быть не короче 6 символов", field: .password)
                hasErrors = true
            } else {
                view?.showError(message: "", field: .password)
            }
        } else {
            view?.showError(message: "", field: .password)
        }
        
        if confirmPasswordWasEdited && !confirmPassword.isEmpty && !password.isEmpty {
            if password != confirmPassword {
                view?.showError(message: "Пароли не совпадают", field: .confirmPassword)
                hasErrors = true
            } else {
                view?.showError(message: "", field: .confirmPassword)
            }
        } else {
            view?.showError(message: "", field: .confirmPassword)
        }
        
        let valid = Validators.isValidName(surname)
            && !name.isEmpty
            && birthDate != nil
            && !Calendar.current.isDateInToday(birthDate ?? Date())
            && Validators.isValidPassword(password)
            && password == confirmPassword
            
        view?.enableRegisterButton(valid && !hasErrors)
    }

    func registerTapped() {
        if surname.count == 0 || !Validators.isValidName(surname) {
            view?.showError(message: "Фамилия слишком короткая", field: .surname)
            return
        }
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            view?.showError(message: "Имя не заполнено", field: .name)
            return
        }
        guard let birthDate = birthDate else {
            view?.showError(message: "Дата рождения не выбрана", field: .birthDate)
            return
        }
        if Calendar.current.isDateInToday(birthDate) {
            view?.showError(message: "Дата рождения не может совпадать с сегодняшним днём", field: .birthDate)
            return
        }
        if !Validators.isValidPassword(password) {
            view?.showError(message: "Пароль должен содержать цифры и буквы верхнего регистра и быть не короче 6 символов", field: .password)
            return
        }
        if password != confirmPassword {
            view?.showError(message: "Пароли не совпадают", field: .confirmPassword)
            return
        }
        UserSession.shared.userName = name
        UserSession.shared.isRegistered = true
        view?.registrationSuccess()
    }
} 
