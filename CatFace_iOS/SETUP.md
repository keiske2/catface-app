# CatFace iOS 개발 환경 설정 가이드

## 1단계: Xcode 프로젝트 생성

### 방법 A: 커맨드라인으로 생성

```bash
cd /Users/kwackbyungjoon/Desktop/CatFace_iOS

# 새 Xcode 프로젝트 생성
mkdir -p CatFace.xcodeproj/project.xcworkspace

# 프로젝트 파일 구조
```

### 방법 B: Xcode GUI로 생성 (권장)

1. **Xcode 실행** (`/Applications/Xcode.app`)

2. **새 프로젝트 생성**
   ```
   File → New → Project
   ```

3. **iOS App 선택**
   ```
   iOS → App → Next
   ```

4. **프로젝트 설정**
   - Product Name: `CatFace`
   - Team: (계정 설정)
   - Organization Identifier: `com.catface`
   - Interface: `SwiftUI`
   - Life Cycle: `SwiftUI App`

5. **저장 위치**
   ```
   /Users/kwackbyungjoon/Desktop/CatFace_iOS
   ```

## 2단계: Swift 파일 추가

생성된 프로젝트에 다음 파일들을 추가하세요:

```
CatFace/
├── CatFaceApp.swift          ← 메인 앱 파일 (자동 생성)
├── ContentView.swift         ← 메인 뷰 (자동 생성)
├── HomeView.swift            ← 새로 추가
├── AnalyzeView.swift         ← 새로 추가
├── SettingsView.swift        ← 새로 추가
├── Models.swift              ← 새로 추가
├── YOLODetector.swift        ← 새로 추가
└── Info.plist                ← 수정
```

### 파일 추가 방법

1. **Xcode에서 우클릭** → New File
2. **Swift File 선택**
3. **이름 입력** (예: HomeView)
4. **Create** 클릭
5. 위의 코드 복사 붙여기

또는

```bash
# 터미널에서 한 번에 복사
cd /Users/kwackbyungjoon/Desktop/CatFace_iOS/CatFace

cp /Users/kwackbyungjoon/Desktop/CatFace_iOS/CatFace/*.swift .
```

## 3단계: Build Settings 설정

1. **프로젝트 선택** → Targets → CatFace
2. **Build Settings** 탭
3. 검색: `IPHONEOS_DEPLOYMENT_TARGET`
4. 값: `15.0` 이상으로 설정

## 4단계: Info.plist 설정

자동 생성된 Info.plist를 다음과 같이 수정:

```plist
<key>NSCameraUsageDescription</key>
<string>고양이 사진을 촬영하기 위해 카메라에 접근합니다</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>고양이 사진을 선택하기 위해 갤러리에 접근합니다</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>고양이 사진을 저장하기 위해 갤러리에 접근합니다</string>
```

## 5단계: Core ML 모델 추가 (옵션)

### YOLO 모델 다운로드

```bash
cd /Users/kwackbyungjoon/Desktop/CatFace_iOS/CatFace

# Core ML 형식 모델 다운로드
curl -L -o yolov8n.mlmodel \
  https://example.com/yolov8n.mlmodel
```

### Xcode에 추가

1. 파일을 Xcode 프로젝트에 드래그
2. "Copy items if needed" 체크
3. Targets: CatFace 선택

## 6단계: 빌드 및 실행

### 빌드

```
⌘ + B  (Product → Build)
```

또는

```bash
xcodebuild -scheme CatFace -configuration Debug
```

### 실행

```
⌘ + R  (Product → Run)
```

또는

```bash
xcodebuild -scheme CatFace -configuration Debug | xcpretty
```

## 7단계: 시뮬레이터 또는 실제 기기

### 시뮬레이터
```
Xcode → Devices and Simulators
선택: iPhone 15 Pro (iOS 17+)
```

### 실제 기기
```
iPhone 연결 → Trust → 서명 설정
Signing & Capabilities 탭에서 Team 선택
```

## 문제 해결

### 빌드 오류: "Cannot find reference"

→ Build Phases → Compile Sources에 모든 .swift 파일이 있는지 확인

### 런타임 오류: "Fatal error in executor"

→ Info.plist의 권한 설정 확인

### 카메라/사진이 작동 안 함

→ 시뮬레이터 설정 → Features → Camera 활성화
또는 실제 기기 → 설정 → CatFace → 카메라 권한 허용

## 다음 단계

1. **Core ML 모델 통합**
   - yolov8n.mlmodel 다운로드
   - YOLODetector.swift에서 모델 로드 코드 활성화

2. **TTS 추가**
   ```swift
   import AVFoundation
   let synth = AVSpeechSynthesizer()
   let utterance = AVSpeechUtterance(string: "감정 텍스트")
   utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
   synth.speak(utterance)
   ```

3. **테스트 고양이 이미지 추가**
   - 샘플 고양이 사진을 앱에 포함

4. **App Store 배포 준비**
   - Bundle ID 설정
   - 아이콘 추가
   - 스크린샷 준비
   - 앱 설명 작성
