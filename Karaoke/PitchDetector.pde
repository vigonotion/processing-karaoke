public abstract class PitchDetector {

  protected final Karaoke karaoke;

  protected float frequency;
  protected float volume;

  public PitchDetector(Karaoke karaoke) {
    this.karaoke = karaoke;
  }

  public abstract void analyze();

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
  //
  // I'm dividing by log(2) because Processing only has a function for log_10
  // log_a(x) / log_a(b) = log_b(x)
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

}
