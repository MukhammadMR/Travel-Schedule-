import Foundation

actor SearchService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/search/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchSearch(from: String, to: String) async throws -> Data {
        guard var components = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to)
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
