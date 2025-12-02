import SwiftUI

struct ChoosingDirectionView: View {
    @Binding var fromCity: String
    @Binding var toCity: String
    let onSelectField: (FieldType) -> Void
    let onSwap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.2156862745, green: 0.4470588235, blue: 0.9058823529, alpha: 1)))
                .frame(width: 343, height: 128)

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: { onSelectField(.from) }) {
                        HStack {
                            Text(fromCity.isEmpty ? "Откуда" : fromCity)
                                .font(.system(size: 17))
                                .foregroundColor(fromCity.isEmpty
                                                 ? Color(#colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1))
                                                 : Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)))
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)

                    Button(action: { onSelectField(.to) }) {
                        HStack {
                            Text(toCity.isEmpty ? "Куда" : toCity)
                                .font(.system(size: 17))
                                .foregroundColor(toCity.isEmpty
                                                 ? Color(#colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1))
                                                 : Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)))
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                }
                .frame(width: 259, height: 96)
                .background(Color.white)
                .cornerRadius(20)

                Spacer(minLength: 0)

                Button(action: onSwap) {
                    Image("changeButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(Circle())
            }
            .padding(.horizontal, 16)
        }
        .frame(width: 343, height: 128)
    }
}

#Preview {
    ChoosingDirectionView(
        fromCity: .constant("Москва"),
        toCity: .constant("Санкт-Петербург"),
        onSelectField: { _ in },
        onSwap: {}
    )
}
