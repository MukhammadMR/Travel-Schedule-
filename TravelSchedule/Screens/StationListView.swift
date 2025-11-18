import SwiftUI

struct Station: Identifiable, Hashable {
    let id = UUID()
    let code: String?
    let title: String
}

struct StationListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    let stations: [Station]
    var onSelect: (Station) -> Void

    private var filtered: [Station] {
        query.isEmpty ? stations :
        stations.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $query)
                .frame(maxWidth: 343)
                .frame(maxWidth: .infinity)
                .padding(.top, 13)

            if filtered.isEmpty {
                Spacer()
                Text("Станции не найдены")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                List(filtered) { station in
                    Button {
                        onSelect(station)
                    } label: {
                        HStack(spacing: 4) {
                            Text(station.title)
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
                    .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowSpacing(0)
                .contentMargins(.top, 0, for: .scrollContent)
                .listSectionSeparator(.hidden)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image("backButton")
                        .resizable().renderingMode(.template)
                        .foregroundColor(.primary)
                        .frame(width: 17, height: 22)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Выбор станции")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
