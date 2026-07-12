import Foundation
import CoreGraphics

struct DetectedCat {
    let bbox: CGRect
    let confidence: Float
    let id: Int
}

struct CatEmotion {
    let type: EmotionType
    let emoji: String
    let label: String
    let confidence: Int
    let description: String
    let isNotCat: Bool

    init(type: EmotionType, emoji: String, label: String, confidence: Int, customDescription: String? = nil, isNotCat: Bool = false) {
        self.type = type
        self.emoji = emoji
        self.label = label
        self.confidence = confidence
        self.isNotCat = isNotCat

        if let custom = customDescription {
            self.description = custom
        } else {
            switch type {
            case .calm:
                self.description = "지금 이 순간이 완벽해. 햇살이 등을 데워주고, 바람 한 점 없이 조용하고, 내 자리도 딱 적당히 따뜻해."

            case .curious:
                self.description = "방금 저기서 뭔가 움직였어. 확실해. 눈을 못 떼겠어. 귀도 최대한 앞으로 당겨서 소리 방향을 잡으려고 하고 있어."

            case .alert:
                self.description = "뭔가 이상해. 분위기가 달라졌어. 경계는 풀면 안 될 것 같아. 지금 귀는 최대한 앞으로 향하고 있어."

            case .annoyed:
                self.description = "지금은 별로야. 기분이 좋지 않은데 왜 계속 건드리는 거야. 꼬리가 저절로 탁탁 쳐지는 거 보이지?"

            case .affection:
                self.description = "너 좋아해. 그냥 그렇게 느껴져서 말하는 거야. 네가 옆에 있으면 이상하게 마음이 편해져."
            }
        }
    }
}

struct CatProfile {
    var name: String = "멍밍이"
    var age: Int = 12
    var breed: String = "러시안 블루"
    var personality: String = "도도"
    var photoData: Data?

    var nyang: Int = 60
    var language: String = "ko"
}
