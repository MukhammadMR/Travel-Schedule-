import SwiftUI

enum FieldType { case from, to }

// MARK: - Main Screen View
struct MainScreenView: View {
    @StateObject private var viewModel = MainScreenViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.selectedTab == 0 {
                    VStack(spacing: 0) {
                        StoriesGroupView(stories: viewModel.stories, viewedStories: viewModel.viewedStories) { index in
                            viewModel.openStory(at: index)
                        }
                        .padding(.top, 44)
                        .padding(.horizontal, 16)
                        
                        ChoosingDirectionView(
                            fromCity: $viewModel.fromCity,
                            toCity: $viewModel.toCity,
                            onSelectField: { field in
                                viewModel.selectField(field)
                            },
                            onSwap: {
                                viewModel.swapDirections()
                            }
                        )
                        .padding(.top, 44)
                        .padding(.horizontal, 16)

                        if viewModel.isSearchEnabled {
                            Button(action: {
                                viewModel.isCarriersPresented = true
                            }) {
                                Text("Найти")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 60)
                                    .background(Color(#colorLiteral(red: 0.2156862745, green: 0.4470588235, blue: 0.9058823529, alpha: 1)))
                                    .cornerRadius(16)
                            }
                            .padding(.top, 20)
                        }
                        
                        Spacer()
                                    
                        NavigationLink("", isActive: $viewModel.isCarriersPresented) {
                            CarriersListView(
                                fromTitle: viewModel.fromCity,
                                toTitle: viewModel.toCity,
                                fromCode: viewModel.fromCode,
                                toCode: viewModel.toCode
                            )
                        }
                        .hidden()
                    }
                } else if viewModel.selectedTab == 1 {
                    SettingsView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $viewModel.selectedTab)
            }
            .background(Color(.systemBackground))
            .fullScreenCover(isPresented: $viewModel.isStoryPresented) {
                if !fullScreenStories.isEmpty {
                    let startIndex = min(viewModel.selectedStoryIndex * 2, fullScreenStories.count - 1)
                    StoryView(story: fullScreenStories[startIndex])
                }
            }
            .fullScreenCover(isPresented: $viewModel.isCityListPresented) {
                NavigationStack {
                    CityListView { selected in
                        viewModel.citySelected(title: selected.title, code: selected.code)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview("MainScreenView") {
    NavigationStack {
        MainScreenView()
    }
}
