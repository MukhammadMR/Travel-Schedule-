
import Foundation

final class StationsListService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/stations_list/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchStationsList(completion: @escaping (Result<Data, Error>) -> Void) {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [ URLQueryItem(name: "apikey", value: apiKey) ]
        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.addValue("text/html", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
