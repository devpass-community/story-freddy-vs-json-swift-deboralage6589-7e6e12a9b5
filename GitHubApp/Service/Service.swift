import Foundation

struct Service {
    
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol = Network()) {
        self.network = network
    }

    func fetchList(of user: String, completion: @escaping ([Repository]?) -> Void) {
        let url = URL(string: "https://api.github.com/users/\(user)/repos")

        guard let url = url else { return }
        network.performGet(url: url) { data in
            if let convertedData = self.convertDataIntoRepositories(data: data) {
                completion(convertedData)
            } else {
                completion(nil)
            }
        }
    }
    
    func convertDataIntoRepositories(data: Data?) -> [Repository]? {
        guard let data = data else { return nil }
        do {
            let decoder = JSONDecoder()
            let repositories = try decoder.decode([Repository].self, from: data)
            return repositories
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
