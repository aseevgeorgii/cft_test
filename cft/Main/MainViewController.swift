import UIKit

final class MainViewController: UIViewController, MainViewProtocol, UITableViewDataSource {
    private lazy var presenter = MainPresenter(view: self)
    private let titleLabel = UILabel()
    private let greetButton = UIButton(type: .system)
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .systemBackground
        title = "Главный экран"
        setupUI()
        stylizeButton()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        titleLabel.text = "Тестовое задание курс iOS"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        greetButton.translatesAutoresizingMaskIntoConstraints = false
        greetButton.setTitle("Приветствие", for: .normal)
        greetButton.addTarget(self, action: #selector(greetTapped), for: .touchUpInside)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self

        view.addSubview(titleLabel)
        view.addSubview(greetButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            greetButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            greetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetButton.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: greetButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func stylizeButton() {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = UIColor(red: 0.36, green: 0.82, blue: 0.36, alpha: 1)
            config.baseForegroundColor = .white
            config.title = "Приветствие"
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32)
            greetButton.configuration = config
            greetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        } else {
            greetButton.layer.cornerRadius = 12
            greetButton.layer.masksToBounds = true
            greetButton.backgroundColor = UIColor(red: 0.36, green: 0.82, blue: 0.36, alpha: 1)
            greetButton.setTitleColor(.white, for: .normal)
            greetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            greetButton.layer.borderWidth = 1
            greetButton.layer.borderColor = UIColor(red: 0.36, green: 0.82, blue: 0.36, alpha: 1).cgColor
            greetButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        }
    }

    @objc private func greetTapped() {
        presenter.greetTapped()
    }

    func reloadData() {
        tableView.reloadData()
    }

    func showGreeting(name: String) {
        let alert = UIAlertController(title: "Привет!", message: "Здравствуйте, \(name)!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let product = presenter.products[indexPath.row]
        cell.textLabel?.text = product.title
        cell.detailTextLabel?.text = "\(product.price) $"
        return cell
    }
} 
