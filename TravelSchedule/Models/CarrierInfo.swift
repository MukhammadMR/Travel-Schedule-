import Foundation

struct CarrierInfo: Decodable, CustomStringConvertible {
    let title: String
    let logo: String?
    let email: String?
    let phone: String?
    let url: String?
    let code: String

    enum CodingKeys: String, CodingKey {
        case title
        case logo
        case email
        case contacts
        case phone
        case url
        case code
    }

    init(title: String, logo: String?, email: String?, phone: String?, url: String?, code: String) {
        self.title = title
        self.logo = logo
        self.email = email
        self.phone = phone
        self.url = url
        self.code = code
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Неизвестно"
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        url = try container.decodeIfPresent(String.self, forKey: .url)

        if let intCode = try? container.decode(Int.self, forKey: .code) {
            code = String(intCode)
        } else {
            code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        }

        print("[CarrierInfo] decoded: title=\(title), code=\(code), email=\(email ?? "nil"), phone=\(phone ?? "nil"), url=\(url ?? "nil")")
    }

    var description: String {
        "CarrierInfo(title: \(title), code: \(code), email: \(email ?? "nil"), phone: \(phone ?? "nil"), url: \(url ?? "nil"))"
    }
}
