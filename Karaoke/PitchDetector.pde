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
  
  public void setAudioIn(AudioIn audioIn) {
    this.audioIn = audioIn;
  }  
  
}