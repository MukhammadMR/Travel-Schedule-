import SwiftUI
import Combine

@MainActor
final class StoryViewModel: ObservableObject {
    @Published var currentIndex: Int
    @Published var progress: CGFloat = 0

    let stories: [Story]

    private var timer: Timer?
    nonisolated private static let storyDuration: TimeInterval = 10
    var onStoriesFinished: (() -> Void)?

    init(startIndex: Int, stories: [Story]) {
        self.currentIndex = startIndex
        self.stories = stories
    }

    func startTimer() {
        invalidateTimer()
        progress = 0

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            let step = 0.05 / Self.storyDuration
            self.progress += step

            if self.progress >= 1 {
                timer.invalidate()
                Task { @MainActor in
                    self.showNextStoryOrFinish()
                }
            }
        }
    }

    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    func showNextStoryOrFinish() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            startTimer()
        } else {
            onStoriesFinished?()
        }
    }

    func showPreviousStory() {
        guard currentIndex > 0 else {
            progress = 0
            startTimer()
            return
        }

        currentIndex -= 1
        startTimer()
    }
}
