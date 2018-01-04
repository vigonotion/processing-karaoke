public class Player {

  Karaoke karaoke;
  AudioInput microphone;
  PitchDetector detector;

  private color noteColor;

  ArrayList<SungNoteElement> notesSung;

  public Player(Karaoke karaoke, AudioInput microphone, color noteColor) {
    this.karaoke = karaoke;
    this.microphone = microphone;
    this.noteColor = noteColor;

    this.detector = new PitchDetector(this.karaoke, this.microphone, 44100, 2048);
    this.notesSung = new ArrayList<SungNoteElement>();
  }

  public void start() {

  }

  public PitchDetector getDetector() {
    return this.detector;
  }

  public float getOffset(int currentNote, float frequency) {

    int currentMidiNormalized = (int)(detector.normalizeMidi(currentNote));

    float sungMidiNormalized = detector.frequencyToNormalizedMidi(frequency);

    float offsetRaw[] = { (currentMidiNormalized-12 - sungMidiNormalized), (currentMidiNormalized - sungMidiNormalized), (currentMidiNormalized+12 - sungMidiNormalized) };

    // Add a circular offset (because 12 is nearer to 1 than to 7...)
    float offset = 0;
    if(abs(offsetRaw[0]) <= 5.5) offset = offsetRaw[0];
    else if(abs(offsetRaw[1]) <= 5.5) offset = offsetRaw[1];
    else if(abs(offsetRaw[2]) <= 5.5) offset = offsetRaw[2];

    return offset;
  }

  public color getNoteColor() {
    return this.noteColor;
  }

}
