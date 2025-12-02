import SwiftUI

struct StoriesGroupView: View {
    let stories: [StoryPreview]
    let viewedStories: Set<String>
    let onStoryTap: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                    let isViewed = viewedStories.contains(story.id)
                    StoryCardView(story: story, isViewed: isViewed)
                        .onTapGesture {
                            onStoryTap(index)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .frame(height: 188)
    }
}

#Preview {
    StoriesGroupView(
        stories: StoryPreview.mockStories,
        viewedStories: [],
        onStoryTap: { _ in }
    )
}
