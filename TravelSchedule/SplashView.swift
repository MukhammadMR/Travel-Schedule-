import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Image("splashScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    SplashView()
}
