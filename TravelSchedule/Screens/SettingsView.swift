import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 32)

                    VStack(spacing: 0) {
                        HStack {
                            Text(viewModel.darkModeTitle)
                                .font(.system(size: 17))
                                .foregroundColor(.primary)
                            Spacer()
                            Toggle("", isOn: $isDarkMode)
                                .labelsHidden()
                        }
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .padding(.horizontal, 16)


                        NavigationLink {
                            NavigationStack {
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 16) {

                                        Text(viewModel.offerTitle)
                                            .font(.system(size: 24, weight: .bold))

                                        Text(viewModel.offerIntro)
                                            .font(.system(size: 17))
                                            .kerning(-0.41)

                                        Text(viewModel.termsTitle)
                                            .font(.system(size: 24, weight: .bold))

                                        Text(viewModel.termsText)
                                            .font(.system(size: 17))
                                            .kerning(-0.41)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                }
                                .navigationTitle(viewModel.userAgreementTitle)
                                .navigationBarTitleDisplayMode(.inline)
                            }
                        } label: {
                            HStack {
                                Text(viewModel.userAgreementTitle)
                                    .font(.system(size: 17))
                                    .foregroundColor(.primary)
                                Spacer()
                                Image("forwardButton")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 11, height: 19)
                                    .foregroundColor(Color("TextPrimary"))
                            }
                            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                            .padding(.horizontal, 16)
                        }
                    }

                    Color.clear
                        .frame(height: 473)

                    Spacer()
                        .frame(height: 0)

                    VStack(spacing: 4) {
                        Text(viewModel.apiInfoText)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Text(viewModel.versionText)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    SettingsView()
}
