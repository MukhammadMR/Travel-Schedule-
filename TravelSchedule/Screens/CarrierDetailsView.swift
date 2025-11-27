import SwiftUI

struct CarrierDetailsView: View {
    @StateObject var viewModel: CarrierDetailsViewModel
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                content
            }
            .padding(16)
        }
        .navigationTitle("Информация о перевозчике")
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

    @ViewBuilder
    private var content: some View {
        if let details = viewModel.details {
            header(details: details)
            contactSection(details: details)
        } else {
            Text("Нет данных о перевозчике")
                .foregroundColor(.secondary)
        }
    }

    private func header(details: CarrierDetailsDTO) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let logo = details.logo,
               let url = URL(string: logo) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color(.systemGray5)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 104)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }

            if let title = details.title, !title.isEmpty {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
            }
        }
    }

    private func contactSection(details: CarrierDetailsDTO) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let email = details.email, !email.isEmpty {
                contactRow(title: "E-mail", value: email) {
                    if let url = URL(string: "mailto:\(email)") {
                        openURL(url)
                    }
                }
            }

            if let phone = details.phone, !phone.isEmpty {
                let digits = phone.filter { "+0123456789".contains($0) }
                contactRow(title: "Телефон", value: phone) {
                    if let url = URL(string: "tel://\(digits)") {
                        openURL(url)
                    }
                }
            }
        }
    }

    private func contactRow(
        title: String,
        value: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(Color(.label))
                Text(value)
                    .font(.system(size: 17))
                    .foregroundColor(Color(.systemBlue))
            }
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .padding(.vertical, 8)
            .background(Color.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CarrierDetailsView(
            viewModel: CarrierDetailsViewModel(carrierId: "demo")
        )
    }
}
