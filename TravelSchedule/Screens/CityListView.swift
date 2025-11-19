import SwiftUI

private struct CityItem: Identifiable, Hashable {
    let id: String
}

struct SelectedStation {
    let title: String
    let code: String
}

struct CityListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var query: String = ""
    @State private var selectedCity: CityItem? = nil
    @State private var debouncedQuery: String = ""
    @State private var debounceWorkItem: DispatchWorkItem? = nil
    @State private var stationsByCity: [String: [Station]] = [:]
    @State private var isLoadingStations = false
    
    let cities = [ "Москва", "Санкт-Петербург", "Сочи", "Горных воздух", "Краснодар", "Казань", "Омск"]
    
    var filteredCities: [String] {
        let trimmedQuery = debouncedQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedQuery.isEmpty { return cities }
        return cities.filter { $0.localizedCaseInsensitiveContains(trimmedQuery) }
    }
    
    var onSelect: ((SelectedStation) -> Void)?
    
    var body: some View {
        NavigationStack {
        ZStack {
        VStack(spacing: 0) {
            SearchBar(text: $query)
                .frame(maxWidth: 343)
                .frame(maxWidth: .infinity)
                .padding(.top, 13)
                .onChange(of: query) { trimmedQuery in
                    debounceWorkItem?.cancel()
                    let work = DispatchWorkItem { debouncedQuery = trimmedQuery }
                    debounceWorkItem = work
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: work)
                }
                .onAppear { if stationsByCity.isEmpty { loadStationsList() } }
            
            if filteredCities.isEmpty {
                Spacer()
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                List(filteredCities, id: \.self) { city in
                    Button {
                        selectedCity = CityItem(id: city)
                    } label: {
                        HStack(spacing: 4) {
                            Text(city)
                                .font(.system(size: 17))
                                .foregroundColor(.primary)
                            Spacer()
                            Image("forwardButton")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 10, height: 17)
                                .foregroundColor(.primary)
                        }
                        .frame(height: 60)
                        .contentShape(Rectangle())
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemBackground))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color(.systemBackground))
                .listSectionSeparator(.hidden)
            }
        }
        .background(Color(.systemBackground))
        .navigationDestination(item: $selectedCity) { item in
            StationListView(
                stations: stationsFor(item.id),
                onSelect: { station in
                    guard let code = station.code, !code.isEmpty else {
                        print("⚠️ Station without yandex code selected: \(station.title)")
                        return
                    }

                    let selected = SelectedStation(title: station.title, code: code)
                    onSelect?(selected)
                    selectedCity = nil
                }
            )
        }
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(
            colorScheme == .dark ? .black : .white,
            for: .navigationBar
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image("backButton")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.primary)
                        .frame(width: 17, height: 22)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
            }
        }
        .accentColor(.primary)
        .navigationBarBackButtonHidden(true)
        }
        }
    }
    
    private func stationsFor(_ city: String) -> [Station] {
        stationsByCity[city] ?? []
    }
    
    private func loadStationsList() {
        guard !isLoadingStations else { return }
        isLoadingStations = true
        StationsListService().fetchStationsList { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(StationsListPayload.self, from: data)
                    var map: [String: [Station]] = [:]
                    for country in decoded.countries {
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
                    DispatchQueue.main.async {
                        self.stationsByCity = map
                        self.isLoadingStations = false
                    }
                } catch {
                    DispatchQueue.main.async { self.isLoadingStations = false }
                    print("Stations decode error: \(error)")
                }
            case .failure(let error):
                DispatchQueue.main.async { self.isLoadingStations = false }
                print("Stations list error: \(error)")
            }
        }
    }
}

private struct StationsListPayload: Decodable {
    let countries: [Country]
}
private struct Country: Decodable { let regions: [Region] }
private struct Region: Decodable { let settlements: [Settlement] }
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

#Preview("CityListView") {
    NavigationStack {
        CityListView(onSelect: { _ in })
    }
}
