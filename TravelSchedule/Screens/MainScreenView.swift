import SwiftUI

enum FieldType { case from, to }

// MARK: - Main Screen View
struct MainScreenView: View {
    @State private var fromCity: String = ""
    @State private var toCity: String = ""
    @State private var fromCode: String = ""
    @State private var toCode: String = ""
    @State private var selectedTab = 0
    @State private var isCityListPresented = false
    @State private var selectedField: FieldType? = nil
    @State private var isCarriersPresented = false
    @State private var isStoryPresented = false
    @State private var selectedStoryIndex: Int = 0
    @State private var viewedStories: Set<String> = []

    private let stories: [StoryPreview] = StoryPreview.mockStories
    
    private var isSearchEnabled: Bool {
        !fromCity.isEmpty && !toCity.isEmpty
    }

    private func swapDirections() {
        swap(&fromCity, &toCity)
        swap(&fromCode, &toCode)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if selectedTab == 0 {
                    VStack(spacing: 0) {
                        StoriesGroupView(stories: stories, viewedStories: viewedStories) { index in
                            viewedStories.insert(stories[index].id)
                            selectedStoryIndex = index
                            isStoryPresented = true
                        }
                        .padding(.top, 44)
                        .padding(.horizontal, 16)
                        
                        ChoosingDirectionView(
                            fromCity: $fromCity,
                            toCity: $toCity,
                            onSelectField: { field in
                                selectedField = field
                                isCityListPresented = true
                            },
                            onSwap: swapDirections
                        )
                        .padding(.top, 44)
                        .padding(.horizontal, 16)

                        if isSearchEnabled {
                            Button(action: {
                                isCarriersPresented = true
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
                                    
                        NavigationLink("", isActive: $isCarriersPresented) {
                            CarriersListView(
                                fromTitle: fromCity,
                                toTitle: toCity,
                                fromCode: fromCode,
                                toCode: toCode
                            )
                        }
                        .hidden()
                    }
                } else if selectedTab == 1 {
                    SettingsView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $selectedTab)
            }
            .background(Color(.systemBackground))
            .fullScreenCover(isPresented: $isStoryPresented) {
                if !fullScreenStories.isEmpty {
                    let startIndex = min(selectedStoryIndex * 2, fullScreenStories.count - 1)
                    StoryView(story: fullScreenStories[startIndex])
                }
            }
            .fullScreenCover(isPresented: $isCityListPresented) {
                NavigationStack {
                    CityListView { selected in
                        if selectedField == .from {
                            fromCity = selected.title
                            fromCode = selected.code
                        } else {
                            toCity = selected.title
                            toCode = selected.code
                        }
                        isCityListPresented = false
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
