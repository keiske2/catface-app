import Foundation

enum EmotionType: String, Codable {
    case calm = "calm"
    case curious = "curious"
    case alert = "alert"
    case annoyed = "annoyed"
    case affection = "affection"
}

struct EmotionDescription {
    let type: EmotionType
    let emoji: String
    let label: String
    let confidence: Int
    let eye: String
    let mouth: String
    let tail: String
    let speeches: [String: [String]]
}

class EmotionDataManager {
    static let shared = EmotionDataManager()

    private let emotions: [EmotionType: EmotionDescription] = [
        .calm: EmotionDescription(
            type: .calm,
            emoji: "😌",
            label: "편안 · 만족",
            confidence: 82,
            eye: "반쯤 감김 (개방 비율 낮음 → 이완)",
            mouth: "다뭄",
            tail: "완만하게 늘어짐",
            speeches: [
                "ko": [
                    "지금 이 순간이 완벽해. 햇살이 등을 데워주고, 바람 한 점 없이 조용하고, 내 자리도 딱 적당히 따뜻해. 뭔가를 원한다거나 어딘가 가야 한다거나 하는 마음이 전혀 없어. 그냥 지금 여기 있는 것만으로 충분히 좋아. 집사가 옆에 있어도 좋고, 없어도 이미 충분히 좋아.",
                    "별일 없이 편안한 날이야. 굳이 무슨 말을 더 해야 할 것도 없는 그런 날. 눈 반쯤 감고 이렇게 있으면 돼. 주변에 위협적인 것도 없고, 낯선 소리도 안 들리고, 냄새도 익숙한 것들뿐이야."
                ],
                "en": [
                    "Right now, everything feels just right. The warmth, the quiet, the stillness — I have no complaints whatsoever. I'm not asking for anything. I'm not going anywhere. This spot, this temperature, this moment is enough.",
                    "Nothing's wrong. Nothing needs to change. I'm simply at peace today. Don't overthink it. Some days are just good days, and today is one of them."
                ],
                "es": [
                    "Ahora mismo me siento perfectamente bien. El calor, la quietud, este rincón mío — no necesito nada más. No pido nada. No me voy a ningún lado.",
                    "No hay nada mal. No necesito cambiar nada. Estoy simplemente en paz. Algunos días son así de buenos, y hoy es uno de ellos."
                ],
                "ja": [
                    "今、この瞬間がちょうどいい。温かさ、静けさ、この場所——何も不満はないよ。何かが欲しいわけでも、どこかに行きたいわけでもない。",
                    "何も問題ない。何も変える必要はない。ただ今日は穏やかでいる。こういう日もあるんだよ、そして今日はそういう日。"
                ],
                "zh": [
                    "现在这一刻感觉刚刚好。温暖、安静、这个角落——我没有任何不满。我不需要任何东西，也不想去任何地方。",
                    "什么都不用改变。就这样静静的，挺好的。有些日子就是这么好，今天就是这样的日子。"
                ],
                "pt": [
                    "Neste momento, tudo está perfeito. O calor, o silêncio, este cantinho meu — não preciso de nada mais. Não estou pedindo nada. Não vou a lugar nenhum.",
                    "Não tem nada de errado. Não precisa mudar nada. Estou simplesmente em paz hoje. Alguns dias são assim, e hoje é um deles."
                ]
            ]
        ),

        .curious: EmotionDescription(
            type: .curious,
            emoji: "👀",
            label: "호기심 · 집중",
            confidence: 76,
            eye: "크게 뜸 (개방 비율 높음)",
            mouth: "다뭄",
            tail: "끝이 살짝 씰룩",
            speeches: [
                "ko": [
                    "방금 저기서 뭔가 움직였어. 확실해. 눈을 못 떼겠어. 귀도 최대한 앞으로 당겨서 소리 방향을 잡으려고 하고 있어. 냄새도 살짝 달라진 것 같아.",
                    "어라? 저거 어디서 난 소리지? 분명히 들었어. 귀를 최대한 앞으로 모아서 방향을 잡으려고 해. 가만있어봐. 또 들릴 것 같은데."
                ],
                "en": [
                    "Something just moved over there. I'm sure of it. I can't look away. My ears are up, fully forward, tracking every sound. The smell is slightly different too.",
                    "Did you hear that? I definitely heard something. I'm trying to pinpoint the direction with my ears. Stay still. It might happen again."
                ],
                "es": [
                    "Algo acaba de moverse por allá. Estoy segura. No puedo apartar la vista. Mis orejas apuntan hacia adelante, captando cada sonido.",
                    "¿Escuchaste eso? Definitivamente escuché algo. Estoy tratando de ubicar la dirección con mis orejas."
                ],
                "ja": [
                    "今、あそこで何かが動いた。確かだよ。目が離せない。耳を全力で前に向けて、あらゆる音を追ってる。",
                    "今の聞こえた？絶対に何か聞こえた。耳で方向を特定しようとしてる。じっとしてて。"
                ],
                "zh": [
                    "刚才那边有什么动了，我确定。移不开眼睛。耳朵全力朝前，追踪每一个声音。",
                    "你听到了吗？我绝对听到了什么声音。正在用耳朵判断方向。"
                ],
                "pt": [
                    "Alguma coisa acabou de se mover lá. Tenho certeza. Não consigo desviar o olhar. Minhas orelhas estão totalmente voltadas para frente.",
                    "Você ouviu isso? Definitivamente ouvi alguma coisa. Estou tentando localizar a direção com minhas orelhas."
                ]
            ]
        ),

        .alert: EmotionDescription(
            type: .alert,
            emoji: "😳",
            label: "경계 · 긴장",
            confidence: 71,
            eye: "크게 뜸 · 동공 확장",
            mouth: "다뭄, 살짝 긴장",
            tail: "몸쪽으로 붙음",
            speeches: [
                "ko": [
                    "뭔가 이상해. 분위기가 달라졌어. 아까랑 똑같은 공간인데 뭔가 달라진 느낌이야. 냄새가 바뀌었거나 소리가 달라진 건지 확실히 모르겠는데, 경계는 풀면 안 될 것 같아.",
                    "낯선 게 생겼어. 갑자기 저게 왜 거기 있는 거야. 아까는 없었는데. 이런 게 갑자기 나타나면 일단 경계하는 게 맞아."
                ],
                "en": [
                    "Something feels off. The atmosphere changed. It's the same place, but something is different — the smell, the sound, I'm not sure which. I'm not letting my guard down yet.",
                    "Something unfamiliar appeared. Why is that there now? It wasn't there before. When something shows up unexpectedly, the right move is to be cautious."
                ],
                "es": [
                    "Algo se siente raro. El ambiente cambió. Es el mismo lugar, pero algo es diferente — el olor, el sonido, no sé cuál. Todavía no voy a bajar la guardia.",
                    "Apareció algo desconocido. ¿Por qué está eso ahí ahora? Antes no estaba. Cuando algo aparece inesperadamente, lo correcto es ser cautelosa."
                ],
                "ja": [
                    "何かがおかしい。雰囲気が変わった。同じ場所なのに、何かが違う感じがする。",
                    "見慣れないものが現れた。なんで今あそこにあるの？さっきはなかったのに。"
                ],
                "zh": [
                    "感觉有点不对劲。气氛变了。是同一个地方，但有什么不一样。",
                    "出现了陌生的东西。那个东西为什么突然在那里？之前没有的。"
                ],
                "pt": [
                    "Algo está estranho. O ambiente mudou. É o mesmo lugar, mas algo é diferente — o cheiro, o som.",
                    "Apareceu algo desconhecido. Por que isso está aí agora? Antes não estava."
                ]
            ]
        ),

        .annoyed: EmotionDescription(
            type: .annoyed,
            emoji: "😾",
            label: "불쾌 · 짜증",
            confidence: 68,
            eye: "가늘게 뜸",
            mouth: "살짝 벌림 · 코 주름",
            tail: "탁탁 치는 느낌",
            speeches: [
                "ko": [
                    "지금은 별로야. 기분이 좋지 않은데 왜 계속 건드리는 거야. 나한테도 혼자 있고 싶은 날이라는 게 있어. 오늘이 딱 그런 날이야.",
                    "그거 마음에 안 들어. 처음엔 참았는데 계속 반복되니까 이제 참기 힘들어. 나는 불편한 걸 그냥 넘어가는 타입이 아니야."
                ],
                "en": [
                    "Not now. I'm not in the mood, and I don't understand why you keep pushing it. I have days when I want to be left alone — days when I don't want to do anything.",
                    "That's the one thing I don't like. I tolerated it at first, but repeated is too much. I don't just let discomfort slide — that's not my style."
                ],
                "es": [
                    "Ahora no. No estoy de humor, y no entiendo por qué sigues insistiendo. Tengo días en que quiero que me dejen sola.",
                    "Eso es lo único que no me gusta. Lo toleré al principio, pero repetido es demasiado."
                ],
                "ja": [
                    "今はやめて。気分が良くないのに、なぜそれを続けるの。一人にしてほしい日というのがある。",
                    "それが気に入らない。最初は我慢してたけど、繰り返されると限界。"
                ],
                "zh": [
                    "现在不行。我没心情，我也不明白你为什么一直这样。我也有想独处的日子。",
                    "那件事我不喜欢。一开始我忍了，但重复太多次就受不了了。"
                ],
                "pt": [
                    "Agora não. Não estou com vontade, e não entendo por que você continua insistindo. Tenho dias em que quero ficar sozinha.",
                    "Isso é a única coisa que não gosto. Tolerei no começo, mas repetido é demais."
                ]
            ]
        ),

        .affection: EmotionDescription(
            type: .affection,
            emoji: "😻",
            label: "친근 · 애정",
            confidence: 79,
            eye: "느린 눈 깜빡임 (신뢰 신호)",
            mouth: "다뭄, 편안",
            tail: "끝이 부드럽게 올라감",
            speeches: [
                "ko": [
                    "너 좋아해. 그냥 그렇게 느껴져서 말하는 거야. 평소에 이런 말 잘 안 하는 거 알지? 근데 오늘은 왠지 그 마음이 크게 느껴져.",
                    "이렇게 같이 있는 거 좋아. 뭔가를 해야 할 것도 없고, 어딘가 가야 할 것도 없이 그냥 이렇게. 내가 네 옆에 자꾸 와서 앉는 건 이유가 있어."
                ],
                "en": [
                    "I like you. I'm saying it because I genuinely feel it right now. You know I don't usually say things like this. But today it feels big.",
                    "I like being here like this with you. No agenda, nowhere to be. I keep coming to sit near you for a reason — it's comfortable."
                ],
                "es": [
                    "Me gustas. Lo digo porque genuinamente lo siento ahora mismo. Sabes que normalmente no digo cosas así.",
                    "Me gusta estar aquí así contigo. Sin agenda, sin ningún lugar al que ir."
                ],
                "ja": [
                    "あなたのことが好き。今、本当にそう感じているから言ってるの。こういうこと普段あまり言わないの知ってるよね？",
                    "こうして一緒にいるのが好き。やることも、行くところも何もなくて、ただこうして。"
                ],
                "zh": [
                    "我喜欢你。因为现在真的有这种感觉才说的。你知道我平时不怎么说这种话吧？",
                    "喜欢这样和你在一起。没有什么特别要做的，也不用去哪里，就这样。"
                ],
                "pt": [
                    "Eu gosto de você. Estou dizendo porque genuinamente sinto isso agora. Você sabe que normalmente não digo coisas assim.",
                    "Gosto de estar aqui assim com você. Sem agenda, sem lugar para ir."
                ]
            ]
        )
    ]

    func getEmotion(_ type: EmotionType) -> EmotionDescription? {
        return emotions[type]
    }

    func getSpeech(emotion: EmotionType, language: String) -> String {
        guard let emo = emotions[emotion],
              let speeches = emo.speeches[language] ?? emo.speeches["ko"],
              !speeches.isEmpty else {
            return "..."
        }
        return speeches.randomElement() ?? speeches[0]
    }
}

let PERSONALITIES = [
    ("느긋", "😌"), ("활발", "⚡"), ("도도", "🧊"), ("애교", "💗"),
    ("겁많음", "🫣"), ("장난꾸러기", "😹"), ("호기심", "🔍"), ("무뚝뚝", "😐"),
    ("예민", "😤"), ("응석받이", "🥺"), ("사교적", "🤗"), ("먹보", "🍗")
]

struct Language {
    let code: String
    let label: String
    let bcp47: String
}

let LANGUAGES = [
    Language(code: "ko", label: "한국어", bcp47: "ko-KR"),
    Language(code: "en", label: "English", bcp47: "en-US"),
    Language(code: "es", label: "Español", bcp47: "es-ES"),
    Language(code: "ja", label: "日本語", bcp47: "ja-JP"),
    Language(code: "zh", label: "中文", bcp47: "zh-CN"),
    Language(code: "pt", label: "Português", bcp47: "pt-BR")
]

let CAT_BREEDS = [
    "코리안 숏헤어(코숏)", "코리안 롱헤어", "믹스/도메스틱",
    "아비시니안", "에게", "아메리칸 밥테일", "아메리칸 컬", "아메리칸 숏헤어",
    "발리니즈", "밤비노", "벵갈", "버만", "봄베이", "브라질리안 숏헤어",
    "브리티시 롱헤어", "브리티시 숏헤어", "샤르트뢰", "콘월 렉스", "데본 렉스",
    "이집션 마우", "유러피안 숏헤어", "엑조틱 숏헤어", "저먼 렉스", "하바나 브라운",
    "하이랜더", "히말라얀", "재패니즈 밥테일", "카오 마니", "코랏",
    "램킨", "라펌", "라이코이", "메인쿤", "맹크스", "먼치킨", "네벨룽",
    "노르웨이 숲", "오시캣", "오리엔탈 롱헤어", "오리엔탈 숏헤어", "페르시안",
    "픽시밥", "라가머핀", "랙돌", "러시안 블루", "사바나", "스코티시 폴드",
    "셀커크 렉스", "샴", "시베리안", "싱가푸라", "스노우슈", "소말리", "스핑크스",
    "태국", "통키니즈", "터키시 앙고라", "터키시 반", "요크 초콜릿"
]

class NyangConverter {
    static func apply(text: String, level: Int) -> String {
        if level == 0 { return text }

        let probability = Float(level) / 100.0
        let sentences = text.split(separator: ".", omittingEmptySubsequences: false).map(String.init)

        var result: [String] = []
        for sentence in sentences {
            var s = sentence.trimmingCharacters(in: .whitespaces)
            if s.isEmpty { continue }

            if Float.random(in: 0...1) < probability {
                s = s.replacingOccurrences(of: ".$", with: "", options: .regularExpression)

                let endings = [("있어", "있냥"), ("이야", "이냥"), ("해", "하냥"), ("봐", "봐냥"),
                               ("자", "자옹"), ("어", "어옹"), ("지", "지냥"), ("다", "다냥"),
                               ("줘", "줘옹"), ("돼", "돼냥")]

                for (from, to) in endings {
                    if s.hasSuffix(from) {
                        s = String(s.dropLast(from.count)) + to
                        break
                    }
                }

                if !s.hasSuffix("냥") && !s.hasSuffix("옹") {
                    s += Bool.random() ? "냥" : "옹"
                }
            }
            result.append(s)
        }

        var joined = result.joined(separator: ". ")
        if level >= 80 && Bool.random() { joined = "그르릉~ " + joined }
        else if level >= 50 && Float.random(in: 0...1) < 0.3 { joined += " 골골…" }

        return joined
    }
}
