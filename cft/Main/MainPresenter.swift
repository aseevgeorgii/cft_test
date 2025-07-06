import Foundation

final class MainPresenter {
    weak var view: MainViewProtocol?
    private(set) var products: [Product] = []

    init(view: MainViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        APIService.shared.fetchProducts { [weak self] products in
            self?.products = products
            self?.view?.reloadData()
        }
    }

    func greetTapped() {
        let name = UserSession.shared.userName ?? ""
        view?.showGreeting(name: name)
    }
} 