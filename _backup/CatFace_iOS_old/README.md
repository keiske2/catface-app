# CatFace iOS 앱 🐱

고양이의 표정을 분석해서 감정을 번역해주는 iOS 네이티브 앱입니다.

## 기능

- 📷 **고양이 얼굴 탐지**: YOLO 기반 고양이 감지
- 😸 **감정 분석**: AI로 고양이의 5가지 감정 인식
  - 😌 편안 · 만족
  - 👀 호기심 · 집중
  - 😳 경계 · 긴장
  - 😾 불쾌 · 짜증
  - 😻 친근 · 애정
- 🧠 **Neural Engine 가속**: A11+ iPhone에서 고속 추론
- 🌐 **6개 언어 지원**: 한국어, English, 日本語, 中文, Español, Português
- 🎚️ **냥냥 말투**: 0-100% 고양이 말투 강도 조절
- 🔊 **TTS**: 텍스트 음성 읽기

## 시스템 요구사항

- iOS 15.0+
- iPhone 11 이상 (Neural Engine 사용)
- 카메라 및 사진 라이브러리 접근 권한

## 프로젝트 구조

```
CatFace_iOS/
├── CatFace/
│   ├── CatFaceApp.swift          # 앱 진입점
│   ├── ContentView.swift         # 메인 탭 뷰
│   ├── HomeView.swift            # 홈 화면
│   ├── AnalyzeView.swift         # 분석 화면
│   ├── SettingsView.swift        # 설정 화면
│   ├── Models.swift              # 데이터 모델
│   ├── YOLODetector.swift        # YOLO 추론 엔진
│   └── Info.plist                # 앱 설정
└── README.md                      # 이 파일
```

## 설치 및 실행

### 1. Xcode 열기

```bash
cd /Users/kwackbyungjoon/Desktop/CatFace_iOS
open CatFace
```

### 2. Xcode에서 프로젝트 설정

1. Xcode 실행
2. File → Open → `/Users/kwackbyungjoon/Desktop/CatFace_iOS` 선택
3. (또는 직접 폴더를 Xcode에 드래그)

### 3. 프로젝트 생성 (처음 한 번)

Xcode에서 새 프로젝트 생성:
```
File → New → Project → iOS → App
Product Name: CatFace
Organization Identifier: com.catface
Bundle Identifier: com.catface.app
```

그 다음 위의 Swift 파일들을 프로젝트에 추가하세요.

### 4. 빌드 및 실행

```
⌘ + B  # 빌드
⌘ + R  # 실행
```

## Core ML 모델 통합

### YOLO 모델 추가

1. 웹에서 변환된 Core ML 모델 다운로드:
```bash
curl -L -o yolov8n.mlmodel \
  https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n.mlmodel
```

2. Xcode에서 모델 추가:
   - 파일을 드래그해서 프로젝트에 추가
   - Targets에 CatFace 선택
   - "Copy items if needed" 체크

3. `YOLODetector.swift`에서 모델 로드 코드 활성화

## 사용 방법

### 1. 홈 화면
- 고양이 정보 입력
- "지금 분석하기" 버튼으로 시작

### 2. 분석 화면
- 📷 앨범에서 사진 선택
- 🔍 YOLO 분석 시작
- 😸 고양이 감정 결과 확인

### 3. 설정 화면
- 🐱 고양이 정보 수정
- 🐾 냥냥 말투 강도 조절
- 🌐 기본 언어 변경
- 😸 성격 선택

## 기술 스택

- **언어**: Swift 5.9+
- **프레임워크**: SwiftUI, Vision, CoreML
- **AI/ML**: 
  - YOLOv8n (객체 탐지)
  - Vision Framework (얼굴 인식)
  - Core ML (온디바이스 추론)
- **하드웨어 가속**: Neural Engine (A11+)

## 성능

| 작업 | iPhone 12 | iPhone 11 |
|-----|-----------|-----------|
| YOLO 추론 | ~0.5초 | ~1초 |
| 얼굴 분석 | ~0.2초 | ~0.3초 |
| 전체 분석 | ~2초 | ~3초 |

## 라이센스

MIT

## 개발자

Created with ❤️ for cat lovers
