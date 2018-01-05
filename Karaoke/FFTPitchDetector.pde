import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

public class FFTPitchDetector extends PitchDetector {

  private final int SAMPLERATE;

  private AudioInput audioInput;

  private FFT fft;

  public FFTPitchDetector(Karaoke karaoke, AudioInput audioInput, int sampleRate, int bands) {
    super(karaoke);

    this.audioInput = audioInput;
    this.SAMPLERATE = sampleRate;

    if(this.audioInput != null) fft = new FFT(audioInput.left.size(), SAMPLERATE);
  }

  @Override
  public void analyze() {

    // Checks if there is input
    if(this.audioInput == null) return;

    // Use a Fast Fourier Transformation to get the current frequency

    // Analyze the spectrum
    fft.forward(audioInput.mix);

    // Get the band with highest frequency
    this.frequency = 0;
    this.volume = 0;
    for(int i = 0; i < SAMPLERATE/2; i++) {
      if(fft.getFreq(i) > this.volume) {
        this.frequency = i;
        this.volume = fft.getFreq(i);
      }
    }
  }

  // Override the current Audio Input
  public void setAudioInput(AudioInput audioInput) {
    this.audioInput = audioInput;
    if(this.audioInput != null) fft = new FFT(audioInput.left.size(), SAMPLERATE);
  }

}
