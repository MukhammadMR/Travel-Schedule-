import Foundation
import Combine

@MainActor
final class CarrierDetailsViewModel: ObservableObject {
    @Published var details: CarrierDetailsDTO?

    private let initialInfo: CarrierInfo?

    init(carrierId _: String? = nil,
         initialInfo: CarrierInfo? = nil) {
        self.initialInfo = initialInfo

        if let info = initialInfo {
            self.details = CarrierDetailsDTO(
                title: info.title,
                logo: info.logo,
                phone: info.phone,
                email: info.email
            )
        }
    }
}
