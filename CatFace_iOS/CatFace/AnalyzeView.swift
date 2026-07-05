import SwiftUI
import PhotosUI

struct AnalyzeView: View {
    @Binding var selectedImage: UIImage?
    @Binding var isAnalyzing: Bool
    @Binding var detectedCats: [DetectedCat]
    @Binding var currentEmotion: CatEmotion?
    @Binding var catName: String

    var onImageSelected: (UIImage) -> Void

    @State private var showingImagePicker = false
    @State private var imagePickerItem: PhotosPickerItem?
    @State private var selectedText: String = ""
    @State private var showingSpeech = false

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
                        // 헤더
                        HStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.purple)
                                .cornerRadius(10)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("표정 분석")
                                    .font(.system(size: 17, weight: .bold))
                                Text(catName)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)

                        // GPU 상태
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text("Neural Engine 준비 완료")
                                .font(.system(size: 11.5, weight: .bold))
                            Spacer()
                        }
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.blue)

                        // 사진 영역
                        VStack(spacing: 12) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                    .cornerRadius(16)
                                    .clipped()
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "cat.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    Text("사진을 올려줘요")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(16)
                            }

                            // 사진 선택 버튼
                            PhotosPicker(selection: $imagePickerItem, matching: .images) {
                                HStack {
                                    Image(systemName: "photo.fill")
                                    Text("앨범에서 사진 선택")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .font(.system(size: 15, weight: .bold))
                            }
                            .onChange(of: imagePickerItem) { oldValue, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImage = uiImage
                                        onImageSelected(uiImage)
                                    }
                                }
                            }

                            // 분석 버튼
                            Button(action: {
                                if let image = selectedImage {
                                    onImageSelected(image)
                                }
                            }) {
                                HStack {
                                    if isAnalyzing {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "magnifyingglass")
                                    }
                                    Text(isAnalyzing ? "분석 중..." : "YOLO 분석 시작")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .font(.system(size: 15, weight: .bold))
                            }
                            .disabled(selectedImage == nil || isAnalyzing)
                            .opacity(selectedImage == nil || isAnalyzing ? 0.5 : 1.0)
                        }

                        // 분석 결과
                        if let emotion = currentEmotion {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(spacing: 12) {
                                    Text(emotion.emoji)
                                        .font(.system(size: 46))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(emotion.label)
                                            .font(.system(size: 22, weight: .bold))
                                        Text("신뢰도 \(emotion.confidence)%")
                                            .font(.system(size: 12.5, weight: .semibold))
                                            .foregroundColor(.gray)
                                    }
                                }

                                // 신뢰도 바
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.gray.opacity(0.2))

                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.73, green: 0.41, blue: 0.55),
                                                Color(red: 0.48, green: 0.37, blue: 0.69)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        .frame(width: CGFloat(emotion.confidence) / 100.0 * 280)
                                }
                                .frame(height: 8)

                                // 감정 설명
                                Text(emotion.description)
                                    .font(.system(size: 14.5, weight: .medium))
                                    .lineHeight(1.6)
                                    .foregroundColor(.gray)

                                // TTS 재생
                                Button(action: { showingSpeech.toggle() }) {
                                    HStack {
                                        Image(systemName: "speaker.wave.2.fill")
                                        Text("음성으로 듣기")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(.green)
                                    .cornerRadius(12)
                                    .font(.system(size: 14, weight: .bold))
                                }
                            }
                            .padding(18)
                            .background(Color.white)
                            .cornerRadius(18)
                            .shadow(radius: 4)
                        }

                        Spacer()
                    }
                    .padding(16)
                }
            }
            .navigationTitle("분석")
        }
    }
}

#Preview {
    AnalyzeView(
        selectedImage: .constant(nil),
        isAnalyzing: .constant(false),
        detectedCats: .constant([]),
        currentEmotion: .constant(CatEmotion(
            type: .calm,
            emoji: "😌",
            label: "편안 · 만족",
            confidence: 82
        )),
        catName: .constant("멍밍이"),
        onImageSelected: { _ in }
    )
}
