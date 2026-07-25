import SwiftUI

struct HomeView: View {
    @Binding var catName: String
    @Binding var catBreed: String
    var onAnalyzePressed: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                // 배경
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.94, green: 0.9, blue: 0.96),
                        Color(red: 0.98, green: 0.9, blue: 0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // 브랜드
                    HStack(spacing: 10) {
                        Image(systemName: "cat.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.77, green: 0.37, blue: 0.55),
                                    Color(red: 0.48, green: 0.37, blue: 0.69)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .cornerRadius(10)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("CatFace")
                                .font(.system(size: 17, weight: .bold))
                            Text("고양이 표정 번역기")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 10)

                    // 고양이 카드
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "cat.fill")
                                .font(.system(size: 32))
                                .frame(width: 56, height: 56)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(14)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(catName)
                                    .font(.system(size: 23, weight: .bold))
                                Text("\(catBreed) · 12살")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "snowflake")
                                .font(.system(size: 12))
                            Text("도도 성격")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(999)
                        .foregroundColor(.blue)
                    }
                    .padding(18)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 6)

                    // 빠른 메뉴
                    HStack(spacing: 12) {
                        QuickButton(icon: "📷", title: "사진 분석", action: onAnalyzePressed)
                        QuickButton(icon: "🎚️", title: "설정", action: {})
                    }

                    // 설명
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Text("📷")
                            Text("사진 업로드 → 고양이 얼굴 탐지")
                                .font(.system(size: 13.5))
                        }
                        HStack(spacing: 8) {
                            Text("👁️")
                            Text("눈·입·꼬리 분석 (AI 기반)")
                                .font(.system(size: 13.5))
                        }
                        HStack(spacing: 8) {
                            Text("🌐")
                            Text("6개 언어로 감정 표현 + TTS")
                                .font(.system(size: 13.5))
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .foregroundColor(.gray)

                    // 분석 버튼
                    Button(action: onAnalyzePressed) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("지금 분석하기")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(15)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .font(.system(size: 15.5, weight: .bold))
                    }

                    Spacer()
                }
                .padding(22)
            }
            .navigationTitle("홈")
        }
    }
}

struct QuickButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 12.5, weight: .bold))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 3)
        }
    }
}

#Preview {
    HomeView(catName: .constant("멍밍이"), catBreed: .constant("러시안 블루"), onAnalyzePressed: {})
}
