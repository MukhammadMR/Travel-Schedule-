import Foundation

struct CopyrightResponse: Decodable {
    let copyright: Copyright
    
    struct Copyright: Decodable {
        let text: String
        let url: String
        let logo_hy: String?
    }
}

actor CopyrightService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/copyright/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchCopyright() async throws -> CopyrightResponse.Copyright {
        guard var components = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }

        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoded = try JSONDecoder().decode(CopyrightResponse.self, from: data)
        return decoded.copyright
    }
}
