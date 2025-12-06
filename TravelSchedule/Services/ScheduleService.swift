import Foundation
actor ScheduleService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/schedule/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchSchedule(stationCode: String) async throws -> Data {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "station", value: stationCode)
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
