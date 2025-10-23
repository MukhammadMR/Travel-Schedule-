import Foundation

struct CopyrightResponse: Decodable {
    let copyright: Copyright
    
    struct Copyright: Decodable {
        let text: String
        let url: String
        let logo_hy: String?
    }
}

final class CopyrightService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/copyright/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchCopyright(completion: @escaping (Result<CopyrightResponse.Copyright, Error>) -> Void) {
        guard var components = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "Bad URL", code: -1)))
            return
        }

        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey)
        ]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "Bad URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CopyrightResponse.self, from: data)
                completion(.success(decoded.copyright))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
