//
//  TabBarButton.swift
//  TravelSchedule
//
//  Created by Мухаммад Махмудов on 02.12.2025.
//

import SwiftUI

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

#Preview {
    TabBarButton(
        icon: "scheduleButton",
        iconLight: "scheduleButtonLight",
        isSelected: true,
        action: {}
    )
}
