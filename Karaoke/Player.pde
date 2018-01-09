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

    this.detector = new FFTPitchDetector(this.karaoke, this.microphone, 44100, 2048);
    this.notesSung = new ArrayList<SungNoteElement>();
  }

  public void start() {

  }

  public PitchDetector getDetector() {
    return this.detector;
  }

  // Calculates the offset from the input to the real note
  public float getOffset(int currentNote, float frequency) {

    // Get the normalized midi of this note (eliminate octaves: c' = c'' = c and so on)
    int currentMidiNormalized = (int)(detector.normalizeMidi(currentNote));

    // Do the same with the sung midi
    float sungMidiNormalized = detector.frequencyToNormalizedMidi(frequency);

    // Calculate the offset in three ways (because 12 is nearer to 1 than to 7...)...
    float offsetRaw[] = { (currentMidiNormalized-12 - sungMidiNormalized), (currentMidiNormalized - sungMidiNormalized), (currentMidiNormalized+12 - sungMidiNormalized) };

    // ... to get the lowest absolute offset
    float offset = 0;
    if(abs(offsetRaw[0]) <= 5.5) offset = offsetRaw[0];
    else if(abs(offsetRaw[1]) <= 5.5) offset = offsetRaw[1];
    else if(abs(offsetRaw[2]) <= 5.5) offset = offsetRaw[2];

    return offset;
  }

  public color getNoteColor() {
    return this.noteColor;
  }

  public int getScore() {

    double score = 0;

    // Each sung note gives points
    // Perfectly sung: 12 points
    // Offset of 4 or more: 0 points
    for(SungNoteElement e : this.notesSung) {
      score += map(constrain(abs(e.getOffset()), 0, 4), 0, 4, 12, 0);
    }

    // Start with a score of 1 to prevent arithmetic exception: / by zero
    if(score==0) score=1;

    return (int)(score);
  }

}
