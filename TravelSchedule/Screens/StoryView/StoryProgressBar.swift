import SwiftUI

struct StoryProgressBar: View {
    let progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.3))
                Capsule()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * max(0, min(progress, 1)))
            }
        }
        .frame(height: 6)
    }
}
