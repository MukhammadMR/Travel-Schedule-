import SwiftUI

struct StoryView: View {
    let stories: [Story]
    @State private var currentIndex: Int
    @State private var timer: Timer?
    @State private var progress: CGFloat = 0

    @Environment(\.dismiss) private var dismiss

    private static let storyDuration: TimeInterval = 10

    init(story: Story, stories: [Story] = fullScreenStories) {
        self.stories = stories
        _currentIndex = State(initialValue: story.index)
    }

    private var currentStory: Story {
        stories[currentIndex]
    }

    var body: some View {
        ZStack(alignment: .top) {
            Image(currentStory.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))

            VStack {
                StoryProgressBars(
                    segmentCount: stories.count,
                    currentIndex: currentIndex,
                    progress: progress
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)

                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    if let title = currentStory.title, !title.isEmpty {
                        Text(title)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                    }

                    if let description = currentStory.description, !description.isEmpty {
                        Text(description)
                            .font(.system(size: 20, weight: .regular))
                            .lineLimit(3)
                            .foregroundColor(.white)
                    }
                }
                .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
            }
        }
        .background(Color.black.ignoresSafeArea())
        .overlay {
            HStack(spacing: 0) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showPreviousStory()
                    }
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showNextStoryOrDismiss()
                    }
            }
        }
        .overlay(alignment: .topTrailing) {
            CloseButton {
                dismissWithCleanup()
            }
            .padding(.top, 50)
            .padding(.trailing, 33)
            .zIndex(1)
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.height > 50 {
                        dismissWithCleanup()
                    } else if value.translation.width < -50 {
                        showNextStoryOrDismiss()
                    } else if value.translation.width > 50 {
                        showPreviousStory()
                    }
                }
        )
        .onAppear {
            startTimer()
        }
        .onDisappear {
            invalidateTimer()
        }
        .animation(.easeInOut, value: currentIndex)
    }

    private func startTimer() {
        invalidateTimer()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            let step = 0.05 / Self.storyDuration
            progress += step
            if progress >= 1 {
                timer.invalidate()
                showNextStoryOrDismiss()
            }
        }
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func dismissWithCleanup() {
        invalidateTimer()
        dismiss()
    }

    private func showNextStoryOrDismiss() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            startTimer()
        } else {
            dismissWithCleanup()
        }
    }

    private func showPreviousStory() {
        guard currentIndex > 0 else {
            progress = 0
            startTimer()
            return
        }
        currentIndex -= 1
        startTimer()
    }
}


#Preview {
    StoryView(story: fullScreenStories[0])
}
