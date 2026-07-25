// YOLO 기반 고양이 감지 및 감정 분석
class YOLODetector {
  constructor() {
    this.model = null;
    this.isReady = false;
    this.loadingPromise = this.loadModel();
  }

  async loadModel() {
    try {
      console.log('YOLO 모델 로딩 중...');
      this.model = await cocoSsd.load();
      this.isReady = true;
      console.log('YOLO 모델 준비 완료');
      return true;
    } catch (error) {
      console.error('모델 로드 실패:', error);
      return false;
    }
  }

  async waitForReady() {
    await this.loadingPromise;
    return this.isReady;
  }

  async detectCat(imageElement) {
    if (!this.isReady) {
      throw new Error('모델이 아직 준비 중입니다');
    }

    try {
      const predictions = await this.model.estimateObjects(imageElement);
      const catDetections = predictions.filter(
        p => p.class === 'cat' && p.score > 0.5
      );

      return {
        success: true,
        hasCat: catDetections.length > 0,
        catCount: catDetections.length,
        confidence: catDetections.length > 0
          ? Math.round(
              (catDetections.reduce((a, b) => a + b.score, 0) /
                catDetections.length) *
                100
            )
          : 0,
        detections: catDetections,
        allPredictions: predictions
      };
    } catch (error) {
      console.error('감지 오류:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  analyzeEmotion(detectionResult, personalityType = '느긋함') {
    if (!detectionResult.success) {
      return {
        emotion: 'error',
        confidence: 0
      };
    }

    const emotions = ['happy', 'anxious', 'tired', 'angry'];
    const weights = {
      happy: 0.4,
      anxious: 0.2,
      tired: 0.2,
      angry: 0.2
    };

    // 고양이 감지도에 따라 감정 가중치 조정
    if (detectionResult.hasCat) {
      const confidence = detectionResult.confidence / 100;
      weights.happy = 0.5 + confidence * 0.3;
      weights.anxious = Math.max(0, 0.15 - confidence * 0.1);
    } else {
      weights.angry = 0.8;
      weights.happy = 0.1;
    }

    // 성격에 따른 감정 편향
    const personalityBias = {
      '활발함': { happy: 1.5, anxious: 0.5, tired: 0.3, angry: 1.0 },
      '도도함': { happy: 0.8, anxious: 0.8, tired: 1.2, angry: 1.3 },
      '까칠함': { happy: 0.7, anxious: 1.0, tired: 1.0, angry: 1.5 },
      '느긋함': { happy: 1.2, anxious: 0.5, tired: 1.3, angry: 0.6 },
      '장난스러움': { happy: 1.4, anxious: 1.0, tired: 0.4, angry: 1.1 },
      '사려깊음': { happy: 0.9, anxious: 0.9, tired: 0.8, angry: 0.5 },
      '겁많음': { happy: 0.6, anxious: 1.5, tired: 1.1, angry: 0.4 },
      '다정함': { happy: 1.3, anxious: 0.6, tired: 0.9, angry: 0.3 },
      '고집쟁이': { happy: 1.0, anxious: 0.7, tired: 0.6, angry: 1.4 },
      '쾌활함': { happy: 1.6, anxious: 0.4, tired: 0.5, angry: 0.5 }
    };

    const bias = personalityBias[personalityType] || personalityBias['느긋함'];

    // 가중치 적용
    const emotionScores = {};
    let totalScore = 0;

    emotions.forEach(emotion => {
      emotionScores[emotion] = (weights[emotion] || 0.25) * (bias[emotion] || 1.0);
      totalScore += emotionScores[emotion];
    });

    // 정규화
    const normalized = {};
    emotions.forEach(emotion => {
      normalized[emotion] = emotionScores[emotion] / totalScore;
    });

    // 가장 높은 감정 선택
    const selectedEmotion = emotions.reduce((a, b) =>
      normalized[a] > normalized[b] ? a : b
    );

    return {
      emotion: selectedEmotion,
      scores: normalized,
      detectionConfidence: detectionResult.confidence
    };
  }
}

// 전역 인스턴스
window.yoloDetector = new YOLODetector();
