import Foundation

struct SearchResponse: Decodable, Sendable {
    let segments: [Segment]?
    let error: SearchAPIError?
    let message: String?
}
