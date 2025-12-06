import Foundation

struct Segment: Decodable, Sendable {
    let departure: String
    let arrival: String
    let duration: Int
    let startDate: String
    let thread: ThreadInfo

    enum CodingKeys: String, CodingKey {
        case departure
        case arrival
        case duration
        case thread
        case startDate = "start_date"
    }
}
