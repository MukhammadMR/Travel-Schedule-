import SwiftUI

struct CarrierLogoView: View {
    let logoURL: String?

    var body: some View {
        if let logoURL,
           !logoURL.isEmpty,
           let url = URL(string: logoURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .empty:
                    ProgressView()
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            .frame(width: 38, height: 38)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image(systemName: "train.side.front.car")
            .resizable()
            .scaledToFit()
            .frame(width: 38, height: 38)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
