import SwiftUI

struct StoryView: View {
    @StateObject private var viewModel: StoryViewModel

    @Environment(\.dismiss) private var dismiss

    init(story: Story, stories: [Story] = fullScreenStories) {
        _viewModel = StateObject(
            wrappedValue: StoryViewModel(
                startIndex: story.index,
                stories: stories
            )
        )
    }

    private var currentStory: Story {
        viewModel.stories[viewModel.currentIndex]
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
                    segmentCount: viewModel.stories.count,
                    currentIndex: viewModel.currentIndex,
                    progress: viewModel.progress
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
                        viewModel.showPreviousStory()
                    }
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.showNextStoryOrFinish()
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
                        viewModel.showNextStoryOrFinish()
                    } else if value.translation.width > 50 {
                        viewModel.showPreviousStory()
                    }
                }
        )
        .onAppear {
            let dismiss = dismiss
            viewModel.onStoriesFinished = { [weak viewModel] in
                viewModel?.invalidateTimer()
                dismiss()
            }
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.invalidateTimer()
        }
        .animation(.easeInOut, value: viewModel.currentIndex)
    }

    private func dismissWithCleanup() {
        viewModel.invalidateTimer()
        dismiss()
    }
}

#Preview {
    StoryView(story: fullScreenStories[0])
}
