import SwiftUI

struct Story {
    let imageName: String
    let title: String?
    let description: String?
    let index: Int
    let total: Int

    init(
        imageName: String,
        title: String? = nil,
        description: String? = nil,
        index: Int = 0,
        total: Int = 1
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.index = index
        self.total = total
    }
}

let fullScreenStories: [Story] = [
    // Story 1
    Story(
        imageName: "storyBackground1",
        title: "Story 1",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 0,
        total: 18
    ),
    Story(
        imageName: "storyBackground2",
        title: "Story 1",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 1,
        total: 18
    ),

    // Story 2
    Story(
        imageName: "storyBackground3",
        title: "Story 2",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 2,
        total: 18
    ),
    Story(
        imageName: "storyBackground4",
        title: "Story 2",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 3,
        total: 18
    ),

    // Story 3
    Story(
        imageName: "storyBackground5",
        title: "Story 3",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 4,
        total: 18
    ),
    Story(
        imageName: "storyBackground6",
        title: "Story 3",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 5,
        total: 18
    ),

    // Story 4
    Story(
        imageName: "storyBackground7",
        title: "Story 4",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 6,
        total: 18
    ),
    Story(
        imageName: "storyBackground8",
        title: "Story 4",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 7,
        total: 18
    ),

    // Story 5
    Story(
        imageName: "storyBackground9",
        title: "Story 5",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 8,
        total: 18
    ),
    Story(
        imageName: "storyBackground10",
        title: "Story 5",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 9,
        total: 18
    ),

    // Story 6
    Story(
        imageName: "storyBackground11",
        title: "Story 6",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 10,
        total: 18
    ),
    Story(
        imageName: "storyBackground12",
        title: "Story 6",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 11,
        total: 18
    ),

    // Story 7
    Story(
        imageName: "storyBackground13",
        title: "Story 7",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 12,
        total: 18
    ),
    Story(
        imageName: "storyBackground14",
        title: "Story 7",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 13,
        total: 18
    ),

    // Story 8
    Story(
        imageName: "storyBackground15",
        title: "Story 8",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 14,
        total: 18
    ),
    Story(
        imageName: "storyBackground16",
        title: "Story 8",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 15,
        total: 18
    ),

    // Story 9
    Story(
        imageName: "storyBackground17",
        title: "Story 9",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 16,
        total: 18
    ),
    Story(
        imageName: "storyBackground18",
        title: "Story 9",
        description: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
        index: 17,
        total: 18
    )
]
