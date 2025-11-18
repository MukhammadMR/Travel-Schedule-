import SwiftUI

struct CarrierCardView: View {
    let carrier: Carrier

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                CarrierLogoView(logoURL: carrier.logo)
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(carrier.name)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(#colorLiteral(red: 0.101, green: 0.105, blue: 0.133, alpha: 1)))

                    if let note = carrier.note {
                        Text(note)
                            .font(.system(size: 12))
                            .foregroundColor(Color(#colorLiteral(red: 1.0, green: 0.337, blue: 0.337, alpha: 1.0)))
                    }
                }

                Spacer()

                Text(carrier.date)
                    .font(.system(size: 12))
                    .foregroundColor(Color(#colorLiteral(red: 0.101, green: 0.105, blue: 0.133, alpha: 1)))
            }

            HStack(spacing: 8) {
                Text(carrier.departure)
                    .font(.system(size: 17))
                    .foregroundColor(Color(#colorLiteral(red: 0.101, green: 0.105, blue: 0.133, alpha: 1)))

                HStack(spacing: 8) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(#colorLiteral(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)))

                    Text(carrier.duration)
                        .font(.system(size: 12))
                        .foregroundColor(Color(#colorLiteral(red: 0.101, green: 0.105, blue: 0.133, alpha: 1)))

                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(#colorLiteral(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)))
                }

                Text(carrier.arrival)
                    .font(.system(size: 17))
                    .foregroundColor(Color(#colorLiteral(red: 0.101, green: 0.105, blue: 0.133, alpha: 1)))
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(#colorLiteral(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)))
        )
    }
}
