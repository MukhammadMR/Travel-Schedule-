import Foundation
import Combine

// MARK: - State

enum StationsListState {
    case idle
    case loading
    case loaded(cities: [String], stationsByCity: [String: [Station]])
    case error(AppErrorType)
}

// MARK: - ViewModel

@MainActor
final class StationsListViewModel: ObservableObject {

    // MARK: - Published

    @Published var state: StationsListState = .idle

    // MARK: - Dependencies

    private let service = StationsListService()

    // MARK: - Public

    func load() {
        if case .loading = state { return }
        state = .loading

        Task {
            do {
                let data = try await fetchStationsList()
                let payload = try decodePayload(from: data)
                let map = mapPayload(payload)
                let sortedCities = map.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }

                state = .loaded(cities: sortedCities, stationsByCity: map)
            } catch {
                state = .error(mapError(error))
            }
        }
    }

    // MARK: - Private Async Wrapper

    private func fetchStationsList() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            service.fetchStationsList { result in
                switch result {
                case .success(let data): continuation.resume(returning: data)
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Helpers

    private func decodePayload(from data: Data) throws -> StationsPayload {
        try JSONDecoder().decode(StationsPayload.self, from: data)
    }

    private func mapPayload(_ payload: StationsPayload) -> [String: [Station]] {
        var result: [String: [Station]] = [:]

        for country in payload.countries {
            for region in country.regions {
                for settlement in region.settlements {
                    let stations = settlement.stations.map { Station(code: $0.code, title: $0.title) }
                    if !stations.isEmpty {
                        result[settlement.title] = stations
                    }
                }
            }
        }

        return result
    }

    private func mapError(_ error: Error) -> AppErrorType {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost: return .noInternet
            default: return .server
            }
        }
        return .server
    }
}

// MARK: - DTO

struct StationsPayload: Decodable {
    let countries: [CountryDTO]
}

struct CountryDTO: Decodable {
    let regions: [RegionDTO]
}

struct RegionDTO: Decodable {
    let settlements: [SettlementDTO]
}

struct SettlementDTO: Decodable {
    let title: String
    let stations: [StationDTO]
}

struct StationDTO: Decodable {
    let title: String
    let code: String
}
