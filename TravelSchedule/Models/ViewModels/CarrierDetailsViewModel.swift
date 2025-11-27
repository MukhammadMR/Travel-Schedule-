import Foundation
import Combine

@MainActor
final class CarrierDetailsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var details: CarrierDetailsDTO?
    @Published var errorMessage: String?

    private let carrierId: String?
    private let initialInfo: CarrierInfo?
    private let service: CarrierDetailsService

    init(carrierId: String? = nil,
         initialInfo: CarrierInfo? = nil,
         service: CarrierDetailsService = CarrierDetailsService()) {
        self.carrierId = carrierId
        self.initialInfo = initialInfo
        self.service = service

        if let info = initialInfo {
            self.details = CarrierDetailsDTO(
                title: info.title,
                logo: info.logo,
                phone: info.phone,
                email: info.email,
                url: info.url
            )
        }
        print("[CarrierDetailsViewModel] init carrierId=\(carrierId ?? "nil"), initialInfo=\(String(describing: initialInfo)), detailsFromInitialInfo=\(String(describing: details))")
    }

    func load() async {
        if let info = initialInfo {
            print("[CarrierDetailsViewModel] load(): using initialInfo, skipping network. info=", info)
            return
        }

        guard let carrierId = carrierId else {
            errorMessage = "Неизвестный перевозчик"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            print("[CarrierDetailsViewModel] fetching details from service for id=\(carrierId)")
            details = try await service.fetchDetails(id: carrierId)
            print("[CarrierDetailsViewModel] details loaded from service: ", String(describing: details))
            errorMessage = nil
        } catch {
            print("[CarrierDetailsViewModel] failed to load carrier details:", error)
            details = nil
            errorMessage = "Не удалось загрузить данные перевозчика"
        }
    }
}
