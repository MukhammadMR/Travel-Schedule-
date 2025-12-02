//
//  CustomTabBar.swift
//  TravelSchedule
//
//  Created by Мухаммад Махмудов on 02.12.2025.
//

import SwiftUI

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

#Preview {
    CustomTabBar(selectedTab: .constant(0))
}
