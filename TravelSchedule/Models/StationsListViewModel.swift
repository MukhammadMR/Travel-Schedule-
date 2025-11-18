import Foundation
import Combine

final class StationsListViewModel: ObservableObject {
    @Published var cities: [String] = []
    @Published var stationsByCity: [String: [Station]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var appError: AppErrorType? = nil

    private let service = StationsListService()

    func load() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        appError = nil

        service.fetchStationsList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(StationsPayload.self, from: data)
                    var map: [String: [Station]] = [:]

                    for country in decoded.countries {
                        for region in country.regions {
                            for settlement in region.settlements {
                                let cityTitle = settlement.title
                                let stations = settlement.stations.map {
                                    Station(code: $0.code, title: $0.title)
                                }
                                if !stations.isEmpty {
                                    map[cityTitle] = stations
                                }
                            }
                        }
                    }

                    DispatchQueue.main.async {
                        self.stationsByCity = map
                        self.cities = map.keys.sorted {
                            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
                        }
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.appError = .server
                        self.isLoading = false
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription

                    if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet, .networkConnectionLost:
                            self.appError = .noInternet
                        default:
                            self.appError = .server
                        }
                    } else {
                        self.appError = .server
                    }

                    self.isLoading = false
                }
            }
        }
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
