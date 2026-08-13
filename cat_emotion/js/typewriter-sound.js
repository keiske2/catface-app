// 타자소리 생성기
class TypewriterSound {
  constructor() {
    this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
  }

  playKeySound() {
    try {
      const ctx = this.audioContext;
      const now = ctx.currentTime;
      const duration = 0.05; // 50ms

      // 타자음 - 짧은 클릭 소리
      const osc = ctx.createOscillator();
      osc.type = 'square';
      osc.frequency.setValueAtTime(200, now);
      osc.frequency.exponentialRampToValueAtTime(100, now + duration);

      const gain = ctx.createGain();
      gain.gain.setValueAtTime(0.2, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + duration);

      osc.connect(gain);
      gain.connect(ctx.destination);

      osc.start(now);
      osc.stop(now + duration);
    } catch (error) {
      console.error('타자음 재생 오류:', error);
    }
  }
}

window.typewriterSound = new TypewriterSound();
