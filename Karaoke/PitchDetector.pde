import processing.sound.*;

public class PitchDetector {
 
  private final int SAMPLERATE;
  private final int BANDS;
  
  private float[] spectrum;
  
  private final Karaoke karaoke;
  private AudioIn audioIn;
  
  private Amplitude analyzer;
  private FFT fft;
  
  public PitchDetector(Karaoke karaoke, AudioIn audioIn, int sampleRate, int bands) {
    
    this.karaoke = karaoke;
    this.audioIn = audioIn;
    
    this.SAMPLERATE = sampleRate;
    this.BANDS = bands;
    
    spectrum = new float[SAMPLERATE];
    
    analyzer = new Amplitude(karaoke);
    analyzer.input(audioIn);
    
    fft = new FFT(karaoke, BANDS);
    fft.input(audioIn);
  }
  
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
  float bandToFrequency(int band) {
    return band * SAMPLERATE / BANDS / 2;
  }
  
  public void setAudioIn(AudioIn audioIn) {
    this.audioIn = audioIn;
  }  
  
}