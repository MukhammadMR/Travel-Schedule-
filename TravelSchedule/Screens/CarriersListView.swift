import SwiftUI

struct Carrier: Identifiable {
    let id = UUID()
    let logo: String
    let name: String
    let note: String?
    let date: String
    let departure: String
    let duration: String
    let arrival: String
}

struct CarriersListView: View {
    @StateObject private var viewModel = CarriersListViewModel()
    @State private var showFilters = false

    let fromTitle: String
    let toTitle: String
    let fromCode: String
    let toCode: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1019607857, green: 0.1058823541, blue: 0.1333333403, alpha: 1))
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("\(fromTitle) → \(toTitle)")
                            .font(.system(size: 24, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(primaryTextColor)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)

                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 8)
                            Spacer()
                        } else {
                            VStack(spacing: 12) {
                                ForEach(viewModel.carriers) { carrier in
                                    CarrierCardView(carrier: carrier)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 100)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }

                Button(action: {
                    showFilters = true
                }) {
                    HStack(spacing: 4) {
                        Text("Уточнить время")
                        if viewModel.hasActiveFilters {
                            Circle()
                                .fill(Color(#colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                }
                .foregroundColor(.white)
                .frame(maxWidth: 343, minHeight: 60)
                .background(Color(#colorLiteral(red: 0.2156862745, green: 0.4470588235, blue: 0.9058823529, alpha: 1)))
                .cornerRadius(16)
                .padding(.bottom, 12)
                .zIndex(1)
            }
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(primaryTextColor)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !viewModel.isLoading && viewModel.carriers.isEmpty {
                VStack {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(
            backgroundColor
                .ignoresSafeArea()
        )
        .sheet(isPresented: $showFilters) {
            NavigationStack {
                FiltersView(filters: $viewModel.filters) {
                    viewModel.applyFilters()
                }
            }
        }
        .task {
            await viewModel.loadCarriers(from: fromCode, to: toCode)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image("backButton")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 17, height: 22)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
    }
}

struct CarrierRowView: View {
    let carrier: Carrier

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image(carrier.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(carrier.name)
                            .font(.system(size: 15, weight: .semibold))
                        if let note = carrier.note {
                            Text(note)
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                        }
                    }
                }
                Spacer()
                Text(carrier.date)
                    .font(.system(size: 13))
            }

            HStack {
                Text(carrier.departure)
                Spacer()
                Text(carrier.duration)
                    .font(.system(size: 13))
                Spacer()
                Text(carrier.arrival)
            }
            .font(.system(size: 15))
        }
        .padding(12)
        .background(Color(#colorLiteral(red: 0.9529, green: 0.9529, blue: 0.9607, alpha: 1)))
        .cornerRadius(16)
    }
}

#Preview("CarrierCardView") {
    CarrierCardView(
        carrier: Carrier(
            logo: "aeroflotLogo",
            name: "Аэрофлот",
            note: "Осталось 3 места",
            date: "12 фев, чт",
            departure: "10:30",
            duration: "2 ч 15 мин",
            arrival: "12:45"
        )
    )
    .padding()
    .background(Color(.systemBackground))
}
