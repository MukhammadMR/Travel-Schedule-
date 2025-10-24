
import Foundation

final class NearestSettlementService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/nearest_settlement/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchNearestSettlement(lat: Double, lng: Double, completion: @escaping (Result<Data, Error>) -> Void) {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lng", value: "\(lng)")
        ]
        guard let url = components.url else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
