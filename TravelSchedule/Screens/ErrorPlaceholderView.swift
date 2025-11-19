import SwiftUI

enum AppErrorType {
    case server
    case noInternet

    var title: String {
        switch self {
        case .server:
            return "Ошибка сервера"
        case .noInternet:
            return "Нет соединения"
        }
    }

    var imageName: String {
        switch self {
        case .server:
            return "serverError"
        case .noInternet:
            return "noInternet"
        }
    }
}

struct ErrorPlaceholderView: View {
    let type: AppErrorType

    var body: some View {
        VStack(spacing: 24) {

            Image(type.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 223, height: 223)
                .clipShape(RoundedRectangle(cornerRadius: 70))

            Text(type.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.top, 221)
    }
}


#Preview("Server Error") {
    ErrorPlaceholderView(type: .server)
        .padding()
        .background(Color(.systemBackground))
}

#Preview("No Internet") {
    ErrorPlaceholderView(type: .noInternet)
        .padding()
        .background(Color(.systemBackground))
}
