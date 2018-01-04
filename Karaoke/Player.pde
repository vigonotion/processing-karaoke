public class Player {

  Karaoke karaoke;
  AudioIn microphone;
  PitchDetector detector;

  ArrayList<SungNoteElement> notesSung;

  public Player(Karaoke karaoke, AudioIn microphone) {
    this.karaoke = karaoke;
    this.microphone = microphone;
    this.microphone.start();
    this.detector = new PitchDetector(this.karaoke, this.microphone, 44100, 2048);
    this.notesSung = new ArrayList<SungNoteElement>();
  }

  public void start() {

  }

  public PitchDetector getDetector() {
    return this.detector;
  }


}
