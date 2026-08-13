// 실제 고양이 울음소리 생성기
class CatVoiceGenerator {
  constructor() {
    this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
    this.isSpeaking = false;
  }

  // 고양이 울음소리 합성
  playCatSound(emotion = 'happy', duration = 0.8) {
    if (this.isSpeaking) return;
    this.isSpeaking = true;

    try {
      const ctx = this.audioContext;
      const now = ctx.currentTime;

      const soundParams = {
        happy: {
          frequency: 800,
          frequency2: 1200,
          modulation: 15,
          resonance: 2200,
          duration: 0.6
        },
        anxious: {
          frequency: 600,
          frequency2: 900,
          modulation: 8,
          resonance: 1800,
          duration: 0.8,
          tremolo: true
        },
        tired: {
          frequency: 400,
          frequency2: 600,
          modulation: 3,
          resonance: 1200,
          duration: 1.2
        },
        angry: {
          frequency: 1200,
          frequency2: 1800,
          modulation: 25,
          resonance: 3000,
          duration: 0.5,
          harsh: true
        }
      };

      const params = soundParams[emotion] || soundParams.happy;
      const endTime = now + params.duration;

      // 주요 톤
      const osc1 = ctx.createOscillator();
      osc1.type = 'sine';
      osc1.frequency.setValueAtTime(params.frequency, now);
      osc1.frequency.exponentialRampToValueAtTime(params.frequency2, endTime);

      // 하모닉 톤
      const osc2 = ctx.createOscillator();
      osc2.type = 'sine';
      osc2.frequency.setValueAtTime(params.frequency * 1.5, now);
      osc2.frequency.exponentialRampToValueAtTime(params.frequency2 * 1.5, endTime);

      // 진동 (비브라토/트레몰로)
      const lfo = ctx.createOscillator();
      lfo.frequency.value = params.modulation;
      lfo.type = 'sine';

      // 필터 - 자연스러운 공명
      const filter = ctx.createBiquadFilter();
      filter.type = 'peaking';
      filter.frequency.value = params.resonance;
      filter.gain.value = 8;
      filter.Q.value = 4;

      // 게인/볼륨 컨트롤
      const gainNode = ctx.createGain();
      gainNode.gain.setValueAtTime(0.3, now);
      gainNode.gain.exponentialRampToValueAtTime(0.01, endTime);

      // LFO를 게인에 연결 (비브라토 효과)
      const lfoGain = ctx.createGain();
      lfoGain.gain.value = params.harsh ? 0.15 : 0.08;
      lfo.connect(lfoGain);
      lfoGain.connect(gainNode.gain);

      // 노이즈 추가 (거친 음질)
      if (params.harsh) {
        const noise = this.createNoiseBuffer(ctx, endTime - now);
        const noiseGain = ctx.createGain();
        noiseGain.gain.value = 0.15;
        noiseGain.gain.exponentialRampToValueAtTime(0.01, endTime);

        noise.connect(filter);
        filter.connect(noiseGain);
        noiseGain.connect(this.audioContext.destination);
      }

      // 연결
      osc1.connect(filter);
      osc2.connect(filter);
      filter.connect(gainNode);
      gainNode.connect(ctx.destination);

      // 시작
      osc1.start(now);
      osc2.start(now);
      lfo.start(now);

      // 종료
      osc1.stop(endTime);
      osc2.stop(endTime);
      lfo.stop(endTime);

      // 완료 처리
      setTimeout(() => {
        this.isSpeaking = false;
      }, params.duration * 1000);

    } catch (error) {
      console.error('음성 생성 오류:', error);
      this.isSpeaking = false;
    }
  }

  // 노이즈 버퍼 생성
  createNoiseBuffer(ctx, duration) {
    const bufferSize = ctx.sampleRate * duration;
    const noiseBuffer = ctx.createBufferSource();
    const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
    const output = buffer.getChannelData(0);

    for (let i = 0; i < bufferSize; i++) {
      output[i] = Math.random() * 2 - 1;
    }

    noiseBuffer.buffer = buffer;
    return noiseBuffer;
  }

  // 여러 번 울음 (반복)
  playMultipleSounds(emotion = 'happy', count = 3, interval = 300) {
    for (let i = 0; i < count; i++) {
      setTimeout(() => {
        this.playCatSound(emotion, 0.5);
      }, i * interval);
    }
  }

  // 웹사이트에서 고양이 울음소리 로드 (옵션)
  async loadCatSoundFromWeb(url) {
    try {
      const response = await fetch(url);
      const arrayBuffer = await response.arrayBuffer();
      const audioBuffer = await this.audioContext.decodeAudioData(arrayBuffer);

      const source = this.audioContext.createBufferSource();
      source.buffer = audioBuffer;
      source.connect(this.audioContext.destination);
      source.start(0);
    } catch (error) {
      console.error('웹 음성 로드 오류:', error);
    }
  }
}

window.catVoiceGenerator = new CatVoiceGenerator();
