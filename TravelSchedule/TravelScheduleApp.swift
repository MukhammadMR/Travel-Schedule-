import SwiftUI

@main
struct TravelScheduleApp: App {
    @StateObject private var launch = AppLaunchState()

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainScreenView()
                    .environmentObject(launch)

                if launch.isSplashVisible {
                    SplashView()
                        .background(Color(.systemBackground))
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onAppear {
                            // минимальная длительность показа
                            launch.start(minimumDuration: 0.8)
                            // имитация первой загрузки данных:
                            preload()
                        }
                }
            }
            .background(Color(.systemBackground)).ignoresSafeArea()
        }
    }

    private func preload() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.6) {
            DispatchQueue.main.async {
                launch.markDataReady()
            }
        }
    }
}
