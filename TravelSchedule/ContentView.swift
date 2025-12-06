//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Мухаммад Махмудов on 16.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var text = "Загрузка..."

    var body: some View {
        Text(text)
            .padding()
            .task {
                do {
                    let data = try await CopyrightService().fetchCopyright()
                    await MainActor.run {
                        text = data.text
                    }
                } catch {
                    await MainActor.run {
                        text = "Ошибка: \(error.localizedDescription)"
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
