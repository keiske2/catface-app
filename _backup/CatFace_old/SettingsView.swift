import SwiftUI

struct SettingsView: View {
    @Binding var catName: String
    @Binding var catBreed: String

    @State private var nyang: Double = 60
    @State private var selectedLanguage = "한국어"
    @State private var selectedPersonality = "도도"

    let languages = ["한국어", "English", "日本語", "中文", "Español"]
    let personalities = ["느긋", "활발", "도도", "애교", "겁많음", "장난꾸러기"]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.94, green: 0.9, blue: 0.96),
                        Color(red: 0.98, green: 0.9, blue: 0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // 고양이 정보
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🐱 고양이 정보")
                                .font(.system(size: 16, weight: .bold))

                            VStack(alignment: .leading, spacing: 6) {
                                Text("이름")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                TextField("이름", text: $catName)
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .font(.system(size: 15))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("품종")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                TextField("품종", text: $catBreed)
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .font(.system(size: 15))
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)

                        // 냥냥 말투
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🐾 고양이 말투 정도")
                                .font(.system(size: 16, weight: .bold))
                            Text("0% = 사람 말투 · 100% = 완전 냥냥")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)

                            Slider(value: $nyang, in: 0...100, step: 10)
                                .tint(Color.purple)

                            HStack {
                                Text("사람")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(Int(nyang))%")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.purple)
                                Spacer()
                                Text("냥냥")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }

                            Text("미리보기: 지금 이 \(nyang > 50 ? "냥냥한" : "편안한") 기분이 좋아")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .italic()
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)

                        // 언어 선택
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🌐 기본 언어")
                                .font(.system(size: 16, weight: .bold))

                            VStack(spacing: 8) {
                                ForEach(languages, id: \.self) { lang in
                                    Button(action: { selectedLanguage = lang }) {
                                        HStack {
                                            Text(lang)
                                                .foregroundColor(.black)
                                            Spacer()
                                            if selectedLanguage == lang {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.purple)
                                            }
                                        }
                                        .padding(12)
                                        .background(selectedLanguage == lang ? Color.purple.opacity(0.1) : Color.white)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)

                        // 성격 선택
                        VStack(alignment: .leading, spacing: 12) {
                            Text("😸 고양이 성격")
                                .font(.system(size: 16, weight: .bold))

                            VStack(spacing: 8) {
                                ForEach(Array(personalities.enumerated()), id: \.offset) { index, personality in
                                    Button(action: { selectedPersonality = personality }) {
                                        HStack {
                                            Text(personality)
                                                .foregroundColor(.black)
                                            Spacer()
                                            if selectedPersonality == personality {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.purple)
                                            }
                                        }
                                        .padding(12)
                                        .background(selectedPersonality == personality ? Color.purple.opacity(0.1) : Color.white)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)

                        // 저장 버튼
                        Button(action: {}) {
                            Text("저장하기")
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .font(.system(size: 15, weight: .bold))
                        }

                        Spacer()
                    }
                    .padding(16)
                }
            }
            .navigationTitle("설정")
        }
    }
}

#Preview {
    SettingsView(catName: .constant("멍밍이"), catBreed: .constant("러시안 블루"))
}
