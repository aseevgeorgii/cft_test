import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}

    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        let url = URL(string: "https://fakestoreapi.com/products")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { completion([]); return }
            let products = (try? JSONDecoder().decode([Product].self, from: data)) ?? []
            DispatchQueue.main.async { completion(products) }
        }.resume()
    }
} 