import SwiftUI
import Combine

final class AppLaunchState: ObservableObject {
    @Published var isSplashVisible = true
    @Published var isDataReady = false

    func start(minimumDuration: TimeInterval = 0.8) {
        DispatchQueue.main.asyncAfter(deadline: .now() + minimumDuration) {
            self.tryHide()
        }
    }
    
    func markDataReady() {
        isDataReady = true
        tryHide()
    }

    private func tryHide() {
        guard isDataReady else { return }
        withAnimation(.easeInOut(duration: 0.35)) {
            isSplashVisible = false
        }
    }
}

