import Foundation

struct CarrierInfo: Decodable {
    let title: String
    let logo: String?

    enum CodingKeys: String, CodingKey {
        case title
        case logo
    }
}
