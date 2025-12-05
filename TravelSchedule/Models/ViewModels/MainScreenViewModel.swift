import Foundation
import Combine

@MainActor
final class MainScreenViewModel: ObservableObject {
    // MARK: - Stored properties
    @Published var fromCity: String = ""
    @Published var toCity: String = ""
    @Published var fromCode: String = ""
    @Published var toCode: String = ""

    @Published var selectedTab: Int = 0
    @Published var isCityListPresented: Bool = false
    @Published var selectedField: FieldType? = nil
    @Published var isCarriersPresented: Bool = false
    @Published var isStoryPresented: Bool = false
    @Published var selectedStoryIndex: Int = 0
    @Published var viewedStories: Set<String> = []

    let stories: [StoryPreview] = StoryPreview.mockStories

    // MARK: - Computed properties
    var isSearchEnabled: Bool {
        !fromCity.isEmpty && !toCity.isEmpty
    }

    // MARK: - Public methods
    func swapDirections() {
        swap(&fromCity, &toCity)
        swap(&fromCode, &toCode)
    }

    func selectField(_ field: FieldType) {
        selectedField = field
        isCityListPresented = true
    }

    func openStory(at index: Int) {
        guard stories.indices.contains(index) else { return }
        viewedStories.insert(stories[index].id)
        selectedStoryIndex = index
        isStoryPresented = true
    }

    func citySelected(title: String, code: String) {
        switch selectedField {
        case .from:
            fromCity = title
            fromCode = code
        case .to:
            toCity = title
            toCode = code
        case nil:
            break
        }

        isCityListPresented = false
    }
}
