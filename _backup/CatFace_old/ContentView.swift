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
                },
                onTouchGesture: { gesture, part in
                    handleTouchGesture(gesture: gesture, part: part)
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
                    // ✅ 고양이 탐지 성공 → 다양한 감정으로 매번 다른 응답
                    currentEmotion = analyzeEmotion(from: detections[0])
                } else {
                    // ❌ 고양이를 찾지 못함 → 화낸다!
                    currentEmotion = analyzeNotCat()
                }
                isAnalyzing = false
            }
        }
    }

    private func analyzeEmotion(from cat: DetectedCat) -> CatEmotion {
        // 매번 다른 감정으로 응답
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

        return emotions.randomElement() ?? emotions[0]
    }

    private func analyzeNotCat() -> CatEmotion {
        // 고양이가 없으면 화낸다!
        let notCatMessages = [
            "아 진짜 화난다! 나 지금 그 사진에 고양이가 없는 줄 알았어? 저게 뭐야... 개? 새? 다른 게 뭐가 있는데... 집사한테 자랑하고 싶으니까 고양이 사진을 올려줘! 제발!",
            "뭐야 이건... 저게 나를 찍으려고 한 거야? 이건 고양이가 아니잖아! 자존심 상해. 나 고양이인데 다른 동물 사진을 보여주다니... 정신 차려 집사.",
            "어? 저게 뭐지? 나한테 고양이가 아닌 사진을 보여줘? 나 고양이야. 고양이! 내 사진을 올려줘 진짜. 아니면 다른 고양이라도... 이 정도 수치는 없어.",
            "이걸로 뭘 하려고 했어? 날 놀리는 건가? 이건... 이건 고양이가 아니잖아! 기분 진짜 나쁨. 제발 내 사진을 올려줘.",
            "정말이야? 이 사진을? 고양이가 하나도 없는데? 집사, 진심으로 실망했어. 그냥 거울 봐. 그게 고양이야. 저건 절대 아니고."
        ]

        let message = notCatMessages.randomElement() ?? notCatMessages[0]

        return CatEmotion(
            type: .annoyed,
            emoji: "😾",
            label: "불쾌 · 짜증",
            confidence: 95,
            customDescription: message,
            isNotCat: true
        )
    }

    private func handleTouchGesture(gesture: String, part: String) {
        let gestures = [
            "swipe": ["아... 쓰다듬어 줘... 계속 해줘", "부드럽게... 아... 기분 좋아", "아... 등을 넘나들며... 기분 좋은데", "쓰다듬기... 최고야", "아... 계속... 더 해줘"],
            "longpress": ["아... 더... 더 강하게... 아... 좋아", "음... 더 오래... 아... 편해", "아... 계속 눌러줘... 기분 좋아", "깊게... 아... 최고야", "더... 더... 아... 아..."],
            "doubletap": ["자꾸 건드리면 화난다!", "뭐해, 자꾸 건드려?", "재빨리 건드리는 거야? 하지만 좋네", "자꾸자꾸... 아 기분 좋은데", "재빨리 두 번? 흠... 괜찮은데?"]
        ]

        if let reactions = gestures[gesture] {
            let message = reactions.randomElement() ?? reactions[0]
            let emoji = ["head": "😸", "body": "😻", "belly": "😾", "tail": "😸", "unknown": "😐"][part] ?? "😐"

            currentEmotion = CatEmotion(
                type: .affection,
                emoji: emoji,
                label: "터치 반응",
                confidence: Int.random(in: 75...95),
                customDescription: message,
                isNotCat: false
            )
        }
    }
}

#Preview {
    ContentView()
}
