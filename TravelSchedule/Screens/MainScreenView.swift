import SwiftUI

enum FieldType { case from, to }

// MARK: - Story Model
struct Story: Identifiable {
    let id: String
    let image: String
    let title: String
}

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
    
    // Моковые данные для сториз
    let stories: [Story] = [
        Story(id: "1", image: "storiesPreview1", title: "Text Text\nText Text\nText Text T..."),
        Story(id: "2", image: "storiesPreview2", title: "Text Text\nText Text\nText Text T..."),
        Story(id: "3", image: "storiesPreview3", title: "Text Text\nText Text\nText Text T..."),
        Story(id: "4", image: "storiesPreview4", title: "Text Text\nText Text\nText Text T..."),
        Story(id: "5", image: "storiesPreview5", title: "Text Text\nText Text\nText Text T..."),
    ]
    
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
            StoriesGroupView(stories: stories)
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
            
            // NavigationLink for city list removed; replaced with .fullScreenCover below
            
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
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $selectedTab)
            }
            .background(Color(.systemBackground))
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

// MARK: - Stories Group View
struct StoriesGroupView: View {
    let stories: [Story]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories) { story in
                    StoryCardView(story: story)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .frame(height: 188)
    }
}

// MARK: - Story Card View
struct StoryCardView: View {
    let story: Story
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.image)
                .resizable()
                .scaledToFill()
                .frame(width: 92, height: 140)
                .clipped()
                .cornerRadius(16)
            
            Text(story.title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(3)
                .padding(8)
        }
        .frame(width: 92, height: 140)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentColor, lineWidth: 4)
        )
    }
}

// MARK: - Choosing Direction View
struct ChoosingDirectionView: View {
    @Binding var fromCity: String
    @Binding var toCity: String
    let onSelectField: (FieldType) -> Void
    let onSwap: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.2156862745, green: 0.4470588235, blue: 0.9058823529, alpha: 1)))
                .frame(width: 343, height: 128)
            
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: { onSelectField(.from) }) {
                        HStack {
                            Text(fromCity.isEmpty ? "Откуда" : fromCity)
                                .font(.system(size: 17))
                                .foregroundColor(fromCity.isEmpty ? Color(#colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)) : Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)))
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)

                    Button(action: { onSelectField(.to) }) {
                        HStack {
                            Text(toCity.isEmpty ? "Куда" : toCity)
                                .font(.system(size: 17))
                                .foregroundColor(toCity.isEmpty ? Color(#colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)) : Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)))
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                }
                .frame(width: 259, height: 96)
                .background(Color.white)
                .cornerRadius(20)
                
                Spacer(minLength: 0)
                
                Button(action: onSwap) {
                    Image("changeButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(Circle())
            }
            .padding(.horizontal, 16)
        }
        .frame(width: 343, height: 128)
    }
    
}

// MARK: - Custom TabBar
struct CustomTabBar: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)

            HStack(spacing: 0) {
                TabBarButton(
                    icon: "scheduleButton",
                    iconLight: "scheduleButtonLight",
                    isSelected: selectedTab == 0
                ) {
                    selectedTab = 0
                }
                .frame(maxWidth: .infinity)

                TabBarButton(
                    icon: "settingsButton",
                    iconLight: "settingsButton",
                    isSelected: selectedTab == 1
                ) {
                    selectedTab = 1
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 40)
            .padding(.top, 11.25)
            .padding(.bottom, 4)
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - TabBar Button
struct TabBarButton: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let icon: String
    let iconLight: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(colorScheme == .dark ? iconLight : icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(isSelected ? .primary : .secondary)
        }
    }
}
