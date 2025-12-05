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
    @State private var selectedCity: CityItem? = nil
    @StateObject private var viewModel = CityListViewModel()
    
    var onSelect: ((SelectedStation) -> Void)?
    
    var body: some View {
        NavigationStack {
        ZStack {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.query)
                .frame(maxWidth: 343)
                .frame(maxWidth: .infinity)
                .padding(.top, 13)
                .onChange(of: viewModel.query) { newValue, _ in
                    viewModel.onQueryChange(newValue)
                }
            
            if viewModel.filteredCities.isEmpty {
                Spacer()
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                List(viewModel.filteredCities, id: \.self) { city in
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
                stations: viewModel.stationsFor(item.id),
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
        .task {
            viewModel.onAppear()
        }
        }
        }
    }
}

#Preview("CityListView") {
    NavigationStack {
        CityListView(onSelect: { _ in })
    }
}
