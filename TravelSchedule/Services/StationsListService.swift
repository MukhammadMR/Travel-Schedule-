import Foundation

actor StationsListService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/stations_list/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchStationsList() async throws -> Data {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [ URLQueryItem(name: "apikey", value: apiKey) ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.addValue("text/html", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
