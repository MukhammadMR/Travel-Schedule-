import Foundation
import Combine

final class CarriersListViewModel: ObservableObject {
    // MARK: - Published State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var appError: AppErrorType? = nil
    @Published var carriers: [Carrier] = []
    @Published var filters = Filters()

    var hasActiveFilters: Bool {
        filters.hasActiveFilters
    }

    private var allCarriers: [Carrier] = []

    // MARK: - Lifecycle
    func onAppear(from fromStation: String, to toStation: String) async {

        guard carriers.isEmpty, !isLoading else {
            return
        }
        await loadCarriers(from: fromStation, to: toStation)
    }

    // MARK: - Public API
    func loadCarriers(from fromStation: String, to toStation: String) async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
            self.appError = nil
        }

        let service = SearchService()
        do {
            let data = try await service.fetchSearch(from: fromStation, to: toStation)

            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[SearchService] raw response:\n\(jsonString)")
            }
            #endif

            let decoder = JSONDecoder()

            do {
                let decoded = try decoder.decode(SearchResponse.self, from: data)

                if let apiError = decoded.error?.text ?? decoded.message {
                    await MainActor.run {
                        self.errorMessage = apiError
                        self.appError = .server
                        self.isLoading = false
                    }
                    return
                }

                guard let segments = decoded.segments, !segments.isEmpty else {
                    await MainActor.run {
                        self.errorMessage = "Вариантов нет"
                        self.isLoading = false
                    }
                    return
                }

                let mapped = segments.map { segment in
                    let carrierDTO = segment.thread.carrier

                    let initialInfo: CarrierInfo? = carrierDTO.map { dto in
                        CarrierInfo(
                            title: dto.title ?? "Неизвестно",
                            logo: dto.logo,
                            email: dto.email,
                            phone: dto.phone ?? "",
                            url: dto.url,
                            code: dto.code ?? ""
                        )
                    }

                    return Carrier(
                        carrierId: carrierDTO?.code ?? "",
                        logo: carrierDTO?.logo ?? "",
                        name: carrierDTO?.title ?? "Неизвестно",
                        note: segment.thread.expressType,
                        date: Self.formatDate(segment.startDate),
                        departure: Self.formatTime(segment.departure),
                        duration: Self.formatDuration(segment.duration),
                        arrival: Self.formatTime(segment.arrival),
                        initialInfo: initialInfo
                    )
                }

                await MainActor.run {
                    self.allCarriers = mapped
                    self.carriers = mapped
                    self.isLoading = false
                }

            } catch let DecodingError.keyNotFound(key, context) {
                print("❌ KEY NOT FOUND:", key.stringValue)
                print("Context:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                await MainActor.run {
                    self.errorMessage = "Ошибка данных от сервера (нет ключа \(key.stringValue))"
                    self.appError = .server
                    self.isLoading = false
                }

            } catch let DecodingError.typeMismatch(type, context) {
                print("❌ TYPE MISMATCH:", type)
                print("Context:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                await MainActor.run {
                    self.errorMessage = "Ошибка данных (тип не совпадает: \(type))"
                    self.appError = .server
                    self.isLoading = false
                }

            } catch let DecodingError.valueNotFound(type, context) {
                print("❌ VALUE NOT FOUND:", type)
                print("Context:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                await MainActor.run {
                    self.errorMessage = "Ошибка данных (не найдено значение: \(type))"
                    self.appError = .server
                    self.isLoading = false
                }

            } catch let DecodingError.dataCorrupted(context) {
                print("❌ DATA CORRUPTED")
                print("Context:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                await MainActor.run {
                    self.errorMessage = "Некорректные данные сервера"
                    self.appError = .server
                    self.isLoading = false
                }

            } catch {
                print("❌ UNKNOWN DECODING ERROR:", error)
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.appError = .server
                    self.isLoading = false
                }
            }
        } catch {
            print("[CarriersListViewModel] DECODING/NETWORK ERROR:", error)
            await MainActor.run {
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
    
    private static func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        if minutes == 0 {
            return "\(hours) часов"
        } else {
            return "\(hours) ч \(minutes) мин"
        }
    }
    
    private static func formatTime(_ raw: String) -> String {
        let timePart: Substring
        if let tIndex = raw.firstIndex(of: "T") {
            let afterT = raw.index(after: tIndex)
            timePart = raw[afterT...]
        } else {
            timePart = Substring(raw)
        }

        let clean = timePart.prefix { $0 != "+" && $0 != " " }
        let components = clean.split(separator: ":")
        if components.count >= 2 {
            return "\(components[0]):\(components[1])"
        } else {
            return String(clean)
        }
    }

    private static func formatDate(_ raw: String) -> String {
        let parts = raw.split(separator: "-")
        guard parts.count == 3,
              let monthInt = Int(parts[1]),
              let dayInt = Int(parts[2]) else {
            return raw
        }
        let months = ["января","февраля","марта","апреля","мая","июня","июля","августа","сентября","октября","ноября","декабря"]
        let monthName = months[min(max(monthInt-1, 0), 11)]
        return "\(dayInt) \(monthName)"
    }

    func applyFilters() {
        var result = allCarriers

        if !filters.selectedSlots.isEmpty {
            result = result.filter { carrier in
                guard let hour = Self.hour(from: carrier.departure) else { return true }
                return Self.matches(hour: hour, slots: filters.selectedSlots)
            }
        }

        if filters.transfers == .no {
            result = result.filter { carrier in
                if let note = carrier.note?.lowercased() {
                    return !note.contains("пересад")
                }
                return true
            }
        }

        DispatchQueue.main.async {
            self.carriers = result
        }
    }

    private static func hour(from timeString: String) -> Int? {
        let components = timeString.split(separator: ":")
        guard let hourString = components.first,
              let hour = Int(hourString) else {
            return nil
        }
        return hour
    }

    private static func matches(hour: Int, slots: Set<DepartureSlot>) -> Bool {
        for slot in slots {
            switch slot {
            case .morning:
                if (6 ..< 12).contains(hour) { return true }
            case .day:
                if (12 ..< 18).contains(hour) { return true }
            case .evening:
                if (18 ..< 24).contains(hour) { return true }
            case .night:
                if (0 ..< 6).contains(hour) { return true }
            }
        }
        return false
    }
}
