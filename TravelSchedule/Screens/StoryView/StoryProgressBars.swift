import SwiftUI

struct StoryProgressBars: View {
    let segmentCount: Int
    let currentIndex: Int
    let progress: CGFloat

    private func progressValue(for index: Int) -> CGFloat {
        if index < currentIndex { return 1 }
        if index == currentIndex { return progress }
        return 0
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0 ..< segmentCount, id: \.self) { index in
                StoryProgressBar(progress: progressValue(for: index))
            }
        }
    }
}
