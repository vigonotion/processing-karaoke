import processing.sound.*;

public class PitchDetector {

  private final int SAMPLERATE;
  private final int BANDS;

  private float[] spectrum;

  private final Karaoke karaoke;
  private AudioIn audioIn;

  private FFT fft;
  private LowPass lowPass;

  private float frequency;
  private float volume;

  public PitchDetector(Karaoke karaoke, AudioIn audioIn, int sampleRate, int bands) {

    this.karaoke = karaoke;
    this.audioIn = audioIn;

    this.SAMPLERATE = sampleRate;
    this.BANDS = bands;

    spectrum = new float[SAMPLERATE];

    lowPass = new LowPass(karaoke);
    lowPass.process(audioIn);

    fft = new FFT(karaoke, BANDS);
    fft.input(audioIn);
  }

  public void analyze() {

    // Use a Fast Fourier Transformation to get the current frequency

    // Analyze the spectrum
    fft.analyze(spectrum);

    // Get the band with highest frequency
    int biggestBand = 0;
    for(int i = 0; i < SAMPLERATE; i++){
      if(spectrum[i] > spectrum[biggestBand]) biggestBand = i;
    }

    this.volume = spectrum[biggestBand];
    this.frequency = bandToFrequency(biggestBand);
  }

  public float getFrequency() {
    return this.frequency;
  }

  public float getVolume() {
    return this.volume;
  }

  // This converts a Band Number to the corresponding frequency
  private float bandToFrequency(int band) {
    return band * SAMPLERATE / BANDS / 2;
  }

  // Converts a Frequency to the Corresponding Midi Tone (with decimals!)
  // Based on the formular found on Wikipedia:
  //
  // MIDI tuning standard. (2017, May 19). In Wikipedia, The Free Encyclopedia.
  // Retrieved 18:14, January 3, 2018, from https://en.wikipedia.org/w/index.php?title=MIDI_tuning_standard&oldid=781221785
  public float frequencyToMidi(float frequency) {
    return 69+12*( log(frequency/440)/log(2) );
  }

  // Normalizes the Midi note (0-12)
  public float normalizeMidi(float midi) {
    if(midi > 127) midi = 127;
    else if(midi < 0) midi = 0;

    int nearest = (int) midi;
    float offset = midi - nearest;

    nearest %= 12;

    return nearest + offset;
  }

  // Combines the methods normalizeMidi() and frequencyToMidi() for ease of use
  public float frequencyToNormalizedMidi(float frequency) {
    return normalizeMidi(frequencyToMidi(frequency));
  }

  // Override the current Audio Input
  public void setAudioIn(AudioIn audioIn) {
    this.audioIn = audioIn;
  }

}
