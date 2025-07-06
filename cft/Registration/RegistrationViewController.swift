import UIKit

final class RegistrationViewController: UIViewController, RegistrationViewProtocol {
    private lazy var presenter = RegistrationPresenter(view: self)

    private let nameTextField = UITextField()
    private let nameErrorLabel = UILabel()
    private let surnameTextField = UITextField()
    private let surnameErrorLabel = UILabel()
    private let birthDateLabel = UILabel()
    private let birthDatePicker = UIDatePicker()
    private let birthDateErrorLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordErrorLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    private let confirmPasswordErrorLabel = UILabel()
    private let registerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .systemBackground
        title = "Регистрация"
        setupUI()
        stylizeTextFields()
        stylizeButton()
    }

    private func setupUI() {
        nameTextField.placeholder = "Имя"
        surnameTextField.placeholder = "Фамилия"
        birthDateLabel.text = "Дата рождения"
        birthDateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        birthDateLabel.textColor = .label
        birthDatePicker.datePickerMode = .date
        birthDatePicker.maximumDate = Date()
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.placeholder = "Подтвердите пароль"
        confirmPasswordTextField.isSecureTextEntry = true
        registerButton.setTitle("Регистрация", for: .normal)
        registerButton.isEnabled = false

        nameTextField.delegate = self
        surnameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        let errorLabels = [nameErrorLabel, surnameErrorLabel, birthDateErrorLabel, passwordErrorLabel, confirmPasswordErrorLabel]
        for errorLabel in errorLabels {
            errorLabel.textColor = .systemRed
            errorLabel.font = .systemFont(ofSize: 12)
            errorLabel.numberOfLines = 0
            errorLabel.isHidden = true
        }

        [nameTextField, nameErrorLabel, surnameTextField, surnameErrorLabel, birthDateLabel, birthDatePicker, birthDateErrorLabel, passwordTextField, passwordErrorLabel, confirmPasswordTextField, confirmPasswordErrorLabel, registerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(surnameChanged), for: .editingChanged)
        birthDatePicker.addTarget(self, action: #selector(birthDateChanged), for: .valueChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            nameErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4),
            nameErrorLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            nameErrorLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),

            surnameTextField.topAnchor.constraint(equalTo: nameErrorLabel.bottomAnchor, constant: padding),
            surnameTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            surnameTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            surnameTextField.heightAnchor.constraint(equalToConstant: 44),

            surnameErrorLabel.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 4),
            surnameErrorLabel.leadingAnchor.constraint(equalTo: surnameTextField.leadingAnchor),
            surnameErrorLabel.trailingAnchor.constraint(equalTo: surnameTextField.trailingAnchor),

            birthDateLabel.topAnchor.constraint(equalTo: surnameErrorLabel.bottomAnchor, constant: padding),
            birthDateLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            birthDateLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            birthDateLabel.heightAnchor.constraint(equalToConstant: 20),

            birthDatePicker.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: padding),
            birthDatePicker.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),

            birthDateErrorLabel.topAnchor.constraint(equalTo: birthDatePicker.bottomAnchor, constant: 4),
            birthDateErrorLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            birthDateErrorLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),

            passwordTextField.topAnchor.constraint(equalTo: birthDateErrorLabel.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: padding),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 44),

            confirmPasswordErrorLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 4),
            confirmPasswordErrorLabel.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            confirmPasswordErrorLabel.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor),

            registerButton.topAnchor.constraint(equalTo: confirmPasswordErrorLabel.bottomAnchor, constant: padding),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            registerButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func stylizeTextFields() {
        let fields = [nameTextField, surnameTextField, passwordTextField, confirmPasswordTextField]
        for field in fields {
            field.layer.cornerRadius = 10
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
            field.backgroundColor = .white
            field.clipsToBounds = true
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
            field.leftViewMode = .always
        }
    }

    private func stylizeButton() {
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = UIColor(red: 0.36, green: 0.82, blue: 0.36, alpha: 1)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor(red: 0.36, green: 0.82, blue: 0.36, alpha: 1).cgColor
    }

    @objc private func nameChanged(_ sender: UITextField) {
        presenter.updateName(sender.text ?? "")
    }
    @objc private func surnameChanged(_ sender: UITextField) {
        presenter.updateSurname(sender.text ?? "")
    }
    @objc private func birthDateChanged(_ sender: UIDatePicker) {
        presenter.updateBirthDate(sender.date)
    }
    @objc private func passwordChanged(_ sender: UITextField) {
        presenter.updatePassword(sender.text ?? "")
    }
    @objc private func confirmPasswordChanged(_ sender: UITextField) {
        presenter.updateConfirmPassword(sender.text ?? "")
    }
    @objc private func registerTapped() {
        presenter.registerTapped()
    }

    func showError(message: String, field: RegistrationField) {
        switch field {
        case .name:
            if message.isEmpty {
                nameErrorLabel.text = nil
                nameErrorLabel.isHidden = true
            } else {
                nameErrorLabel.text = message
                nameErrorLabel.isHidden = false
            }
        case .surname:
            if message.isEmpty {
                surnameErrorLabel.text = nil
                surnameErrorLabel.isHidden = true
            } else {
                surnameErrorLabel.text = message
                surnameErrorLabel.isHidden = false
            }
        case .birthDate:
            if message.isEmpty {
                birthDateErrorLabel.text = nil
                birthDateErrorLabel.isHidden = true
            } else {
                birthDateErrorLabel.text = message
                birthDateErrorLabel.isHidden = false
            }
        case .password:
            if message.isEmpty {
                passwordErrorLabel.text = nil
                passwordErrorLabel.isHidden = true
            } else {
                passwordErrorLabel.text = message
                passwordErrorLabel.isHidden = false
            }
        case .confirmPassword:
            if message.isEmpty {
                confirmPasswordErrorLabel.text = nil
                confirmPasswordErrorLabel.isHidden = true
            } else {
                confirmPasswordErrorLabel.text = message
                confirmPasswordErrorLabel.isHidden = false
            }
        }
    }
    
    private func hideAllErrors() {
        nameErrorLabel.isHidden = true
        surnameErrorLabel.isHidden = true
        birthDateErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
    }

    func enableRegisterButton(_ enabled: Bool) {
        registerButton.isEnabled = enabled
        if enabled {
            hideAllErrors()
        }
    }

    func registrationSuccess() {
        hideAllErrors()
        let mainVC = MainViewController()
        navigationController?.setViewControllers([mainVC], animated: true)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
