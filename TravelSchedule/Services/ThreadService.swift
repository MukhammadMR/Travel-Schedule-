
import Foundation

final class ThreadService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/thread/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchThread(uid: String, completion: @escaping (Result<Data, Error>) -> Void) {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "uid", value: uid)
        ]
        guard let url = components.url else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
