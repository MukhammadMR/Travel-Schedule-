import Foundation

struct ThreadInfo: Decodable {
    let uid: String?
    let carrier: CarrierInfo?
    let expressType: String?

    enum CodingKeys: String, CodingKey {
        case uid
        case carrier
        case expressType = "express_type"
    }
}


