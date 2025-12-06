import Foundation

struct StoryPreview: Identifiable, Sendable {
    let id: String
    let image: String
    let title: String
}

extension StoryPreview {
    static let mockStories: [StoryPreview] = [
        StoryPreview(id: "1", image: "storiesPreview1", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "2", image: "storiesPreview2", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "3", image: "storiesPreview3", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "4", image: "storiesPreview4", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "5", image: "storiesPreview5", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "6", image: "storiesPreview6", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "7", image: "storiesPreview7", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "8", image: "storiesPreview8", title: "Text Text\nText Text\nText Text T..."),
        StoryPreview(id: "9", image: "storiesPreview9", title: "Text Text\nText Text\nText Text T...")
    ]
}
