import SwiftUI

struct SettingsView: View {
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
                            Text("Темная тема")
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

                                        Text(
                                            """
                                            Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум
                                            для физических лиц
                                            """
                                        )
                                            .font(.system(size: 24, weight: .bold))

                                        Text(
                                            """
                                            Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer

                                            Российская Федерация, город Москва
                                            """
                                        )
                                            .font(.system(size: 17))
                                            .kerning(-0.41)

                                        Text("1. ТЕРМИНЫ")
                                            .font(.system(size: 24, weight: .bold))

                                        Text(
                                            """
                                            Понятия, используемые в Оферте, означают следующее:

                                            Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.

                                            Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения Студент знакомится с работой Сервиса и определяет возможность продолжения обучения в рамках Полного курса.

                                            Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
                                            """
                                        )
                                            .font(.system(size: 17))
                                            .kerning(-0.41)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                }
                                .navigationTitle("Пользовательское соглашение")
                                .navigationBarTitleDisplayMode(.inline)
                            }
                        } label: {
                            HStack {
                                Text("Пользовательское соглашение")
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
                        Text("Приложение использует API «Яндекс.Расписаний»")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Text("Версия 1.0 (beta)")
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
