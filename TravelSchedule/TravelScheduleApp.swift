import SwiftUI

@main
struct TravelScheduleApp: App {
    @StateObject private var launch = AppLaunchState()
    @AppStorage("isDarkMode") private var isDarkMode = false

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
                            launch.start(minimumDuration: 0.8)
                            preload()
                        }
                }
            }
            .background(Color(.systemBackground)).ignoresSafeArea()
            .preferredColorScheme(isDarkMode ? .dark : .light)
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
