import SwiftUI

enum DepartureSlot: String, CaseIterable, Identifiable {
    case morning, day, evening, night

    var id: Self { self }

    var title: String {
        switch self {
        case .morning: return "Утро 06:00 - 12:00"
        case .day:     return "День 12:00 - 18:00"
        case .evening: return "Вечер 18:00 - 00:00"
        case .night:   return "Ночь 00:00 - 06:00"
        }
    }
}

enum TransfersFilter {
    case yes, no
}

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @Binding var filters: Filters
    let onApply: () -> Void

    private var controlsColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 0) {
                ForEach(DepartureSlot.allCases) { slot in
                    HStack {
                        Text(slot.title)
                            .font(.system(size: 17))
                        Spacer()
                        Button {
                            if filters.selectedSlots.contains(slot) {
                                filters.selectedSlots.remove(slot)
                            } else {
                                filters.selectedSlots.insert(slot)
                            }
                        } label: {
                            Image(systemName: filters.selectedSlots.contains(slot)
                                  ? "checkmark.square.fill"
                                  : "square")
                                .font(.system(size: 24))
                                .foregroundColor(controlsColor)
                        }
                    }
                    .frame(height: 60)
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Показывать варианты с пересадками")
                    .font(.system(size: 24, weight: .bold))

                radioRow(title: "Да", isSelected: filters.transfers == .yes) {
                    filters.transfers = .yes
                }
                radioRow(title: "Нет", isSelected: filters.transfers == .no) {
                    filters.transfers = .no
                }
            }

            Spacer()

            Button("Применить") {
                onApply()
                dismiss()
            }
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: 343, minHeight: 60)
            .background(Color(#colorLiteral(red: 0.2156862745,
                                           green: 0.4470588235,
                                           blue: 0.9058823529,
                                           alpha: 1)))
            .cornerRadius(16)
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image("backButton")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 17, height: 22)
                        .foregroundColor(controlsColor)
                }
            }
        }
    }

    private func radioRow(title: String,
                          isSelected: Bool,
                          action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 17))
            Spacer()
            Button(action: action) {
                Image(systemName: isSelected
                      ? "circle.inset.filled"
                      : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(controlsColor)
            }
        }
        .frame(height: 44)
    }
}

#Preview("FiltersView") {
    NavigationStack {
        FiltersView(
            filters: .constant(
                Filters(
                    selectedSlots: [.morning, .evening],
                    transfers: .yes
                )
            ),
            onApply: {}
        )
    }
}
