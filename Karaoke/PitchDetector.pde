import processing.sound.*;

public class PitchDetector {

  private final int SAMPLERATE;
  private final int BANDS;

  private float[] spectrum;

  private final Karaoke karaoke;
  private AudioIn audioIn;

  private Amplitude analyzer;
  private FFT fft;
  private LowPass lowPass;

  public PitchDetector(Karaoke karaoke, AudioIn audioIn, int sampleRate, int bands) {

    this.karaoke = karaoke;
    this.audioIn = audioIn;

    this.SAMPLERATE = sampleRate;
    this.BANDS = bands;

    spectrum = new float[SAMPLERATE];

    lowPass = new LowPass(karaoke);
    lowPass.process(audioIn);

    analyzer = new Amplitude(karaoke);
    analyzer.input(audioIn);

    fft = new FFT(karaoke, BANDS);
    fft.input(audioIn);
  }

  // Use a Fast Fourier Transformation to get the current frequency
  public float getCurrentFrequency() {

    // Analyze the spectrum
    fft.analyze(spectrum);

    // Get the band with highest frequency
    int biggestBand = 0;
    for(int i = 0; i < SAMPLERATE; i++){
      if(spectrum[i] > spectrum[biggestBand]) biggestBand = i;
    }

    return bandToFrequency(biggestBand);
  }

  // This converts a Band Number to the corresponding frequency
  private float bandToFrequency(int band) {
    return band * SAMPLERATE / BANDS / 2;
  }

  // Converts a Frequency to the Corresponding Midi Tone (with decimals!)
  private float frequencyToMidi(float frequency) {
    return 69+12*( log(frequency/440)/log(2) );
  }

  // Normalizes the Midi note (0-12)
  private float normalizeMidi(float midi) {
    if(midi > 127) midi = 127;
    else if(midi < 0) midi = 0;

    int nearest = (int) midi;
    float offset = midi - nearest;

    nearest %= 12;

    return nearest + offset;
  }

  // Override the current Audio Input
  public void setAudioIn(AudioIn audioIn) {
    this.audioIn = audioIn;
  }

}
