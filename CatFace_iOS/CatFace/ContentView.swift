import SwiftUI

struct ContentView: View {
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var detectedCats: [DetectedCat] = []
    @State private var currentEmotion: CatEmotion?
    @State private var catName = "멍밍이"
    @State private var catBreed = "러시안 블루"
    @State private var currentTab = 0

    let yoloDetector = YOLODetector.shared

    var body: some View {
        TabView(selection: $currentTab) {
            // 탭 1: 홈
            HomeView(
                catName: $catName,
                catBreed: $catBreed,
                onAnalyzePressed: {
                    currentTab = 1
                }
            )
            .tag(0)
            .tabItem {
                Label("홈", systemImage: "house.fill")
            }

            // 탭 2: 분석
            AnalyzeView(
                selectedImage: $selectedImage,
                isAnalyzing: $isAnalyzing,
                detectedCats: $detectedCats,
                currentEmotion: $currentEmotion,
                catName: $catName,
                onImageSelected: { image in
                    selectedImage = image
                    analyzeImage(image)
                }
            )
            .tag(1)
            .tabItem {
                Label("분석", systemImage: "camera.fill")
            }

            // 탭 3: 설정
            SettingsView(
                catName: $catName,
                catBreed: $catBreed
            )
            .tag(2)
            .tabItem {
                Label("설정", systemImage: "gear")
            }
        }
    }

    private func analyzeImage(_ image: UIImage) {
        isAnalyzing = true

        DispatchQueue.global(qos: .userInitiated).async {
            let detections = yoloDetector.detectCats(in: image)

            DispatchQueue.main.async {
                detectedCats = detections
                if !detections.isEmpty {
                    currentEmotion = analyzeEmotion(from: detections[0])
                }
                isAnalyzing = false
            }
        }
    }

    private func analyzeEmotion(from cat: DetectedCat) -> CatEmotion {
        let emotions = [
            CatEmotion(
                type: .calm,
                emoji: "😌",
                label: "편안 · 만족",
                confidence: Int.random(in: 75...90)
            ),
            CatEmotion(
                type: .curious,
                emoji: "👀",
                label: "호기심 · 집중",
                confidence: Int.random(in: 70...85)
            ),
            CatEmotion(
                type: .alert,
                emoji: "😳",
                label: "경계 · 긴장",
                confidence: Int.random(in: 65...80)
            ),
            CatEmotion(
                type: .annoyed,
                emoji: "😾",
                label: "불쾌 · 짜증",
                confidence: Int.random(in: 60...75)
            ),
            CatEmotion(
                type: .affection,
                emoji: "😻",
                label: "친근 · 애정",
                confidence: Int.random(in: 75...88)
            )
        ]

        return emotions.max(by: { $0.confidence < $1.confidence }) ?? emotions[0]
    }
}

#Preview {
    ContentView()
}
