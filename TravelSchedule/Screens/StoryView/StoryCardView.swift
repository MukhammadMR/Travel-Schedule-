import SwiftUI

struct StoryCardView: View {
    let story: StoryPreview
    let isViewed: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.image)
                .resizable()
                .scaledToFill()
                .frame(width: 92, height: 140)
                .clipped()
                .cornerRadius(16)
                .opacity(isViewed ? 0.4 : 1.0)

            Text(story.title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(3)
                .padding(8)
        }
        .frame(width: 92, height: 140)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isViewed ? Color.clear : Color.accentColor, lineWidth: 4)
        )
    }
}

#Preview {
    StoryCardView(
        story: StoryPreview.mockStories.first!,
        isViewed: false
    )
}
