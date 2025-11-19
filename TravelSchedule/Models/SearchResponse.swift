import Foundation

struct SearchResponse: Decodable {
    let segments: [Segment]?
    let error: SearchAPIError?
    let message: String?
}
