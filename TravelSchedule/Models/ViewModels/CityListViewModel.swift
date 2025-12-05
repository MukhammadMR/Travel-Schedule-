import SwiftUI
import Combine

@MainActor
final class CityListViewModel: ObservableObject {

    // MARK: - Input

    @Published var query: String = ""
    @Published var debouncedQuery: String = ""

    // MARK: - Data

    @Published var stationsByCity: [String: [Station]] = [:]
    @Published var isLoadingStations = false

    // MARK: - Private

    private var debounceWorkItem: DispatchWorkItem?
    private let decoder = JSONDecoder()

    // MARK: - Computed

    var cities: [String] {
        stationsByCity.keys.sorted()
    }

    var filteredCities: [String] {
        let trimmedQuery = debouncedQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedQuery.isEmpty
        ? cities
        : cities.filter { $0.localizedCaseInsensitiveContains(trimmedQuery) }
    }

    // MARK: - Lifecycle

    func onAppear() {
        if stationsByCity.isEmpty {
            Task { [weak self] in
                await self?.loadStationsList()
            }
        }
    }

    // MARK: - Query handling

    func onQueryChange(_ text: String) {
        query = text

        debounceWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.debouncedQuery = text
        }
        debounceWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: work)
    }

    // MARK: - Public helpers

    func stationsFor(_ city: String) -> [Station] {
        stationsByCity[city] ?? []
    }

    // MARK: - Networking

    private func loadStationsList() async {
        guard !isLoadingStations else { return }
        isLoadingStations = true

        let service = StationsListService()

        do {
            let data = try await service.fetchStationsList()
            let decoded = try decoder.decode(StationsListPayload.self, from: data)

            var map: [String: [Station]] = [:]
            for country in decoded.countries where country.title == "Россия" {
                for region in country.regions {
                    for settlement in region.settlements {
                        let cityTitle = settlement.title
                        let items = (settlement.stations ?? []).compactMap { item -> Station? in
                            guard let code = item.codes?.yandexCode, !code.isEmpty else {
                                return nil
                            }
                            return Station(code: code, title: item.title)
                        }
                        if !items.isEmpty {
                            map[cityTitle, default: []].append(contentsOf: items)
                        }
                    }
                }
            }

            stationsByCity = map
            isLoadingStations = false
        } catch {
            isLoadingStations = false
            print("Stations list error: \(error)")
        }
    }
}

// MARK: - DTOs

private struct StationsListPayload: Decodable {
    let countries: [Country]
}

private struct Country: Decodable {
    let title: String
    let regions: [Region]
}

private struct Region: Decodable {
    let settlements: [Settlement]
}

private struct Settlement: Decodable {
    let title: String
    let stations: [StationItem]?
}

private struct StationItem: Decodable {
    let title: String
    let codes: Codes?

    struct Codes: Decodable {
        let yandexCode: String?

        enum CodingKeys: String, CodingKey {
            case yandexCode = "yandex_code"
        }
    }
}
