import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

public class PitchDetector {

  private final int SAMPLERATE;

  private final Karaoke karaoke;
  private AudioInput audioInput;

  private FFT fft;

  private float frequency;
  private float volume;

  public PitchDetector(Karaoke karaoke, AudioInput audioInput, int sampleRate, int bands) {

    this.karaoke = karaoke;
    this.audioInput = audioInput;

    this.SAMPLERATE = sampleRate;

    fft = new FFT(audioInput.left.size(), SAMPLERATE);
  }

  public void analyze() {

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

  public float getFrequency() {
    return this.frequency;
  }

  public float getVolume() {
    return this.volume;
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
  public void setAudioInput(AudioInput audioInput) {
    this.audioInput = audioInput;
  }

}
