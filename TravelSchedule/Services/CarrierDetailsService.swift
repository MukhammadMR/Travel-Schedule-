//
//  CarrierDetailsService.swift
//  TravelSchedule
//
//  Created by Мухаммад Махмудов on 27.11.2025.
//

import Foundation

final class CarrierDetailsService {
    private let baseURL = "https://api.rasp.yandex.net/v3.0/carrier/"
    private let apiKey = "d9ed364d-0959-41b6-8875-e23bc0375f5b"

    func fetchDetails(id: String) async throws -> CarrierDetailsDTO {
        guard var components = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "code", value: id),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(CarrierDetailsDTO.self, from: data)
    }
}
