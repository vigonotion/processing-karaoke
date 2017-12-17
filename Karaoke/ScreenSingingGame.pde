import processing.video.*;

public class ScreenSingingGame extends Screen {

  private final long ANALYZATION_DELAY = 20;

  private boolean isPaused;

  private Assets assets;

  private Movie movie;
  private KaraokeFile kFile;

  private String firstLine = "";
  private String secondLine = "";

  private AudioIn mic1;

  private PitchDetector detector1;

  private long lastAnalysed;
  private ArrayList<SungNoteElement> notesSung;

  public ScreenSingingGame(Karaoke karaoke, KaraokeFile kFile) {
    super(karaoke);

    this.assets = this.karaoke.getAssets();

    this.kFile = kFile;

    this.movie = new Movie(this.karaoke, kFile.getMoviePath());
    this.movie.frameRate(24);

    this.mic1 = new AudioIn(this.karaoke, 1);
    this.mic1.start();
    this.detector1 = new PitchDetector(this.karaoke, this.mic1, 44100, 2048);

    this.lastAnalysed = millis();
    this.notesSung = new ArrayList<SungNoteElement>();
  }

  @Override
  public void start() {
    this.isRunning = true;
    this.isPaused = false;
    movie.play();
    kFile.play(movie);
    kFile.dot.play();
  }

  @Override
  public void draw() {

    if(!isRunning) return;

    canvas.beginDraw();
    canvas.clear();

    if(movie.available()) {
      movie.read();
    }

    canvas.tint(50);
    canvas.image(movie, 0, 0, width, height);

    // Show the Pause Screen
    if(isPaused) {
      canvas.fill(255);
      canvas.textFont(assets.font_QuickSand_Bold);
      canvas.textSize(42);
      canvas.text("Spiel pausiert", 50, 90);

      canvas.textFont(assets.font_QuickSand);
      canvas.textSize(30);
      canvas.text(kFile.getArtist() + " - " + kFile.getTitle(), 50, 130);
    }

    // Or show the Game Screen
    else {
      canvas.fill(255);
      canvas.textFont(assets.font_QuickSand_Bold);
      canvas.textSize(42);
      canvas.text(kFile.getTitle(), 50, 90);

      canvas.textFont(assets.font_QuickSand);
      canvas.textSize(30);
      canvas.text(kFile.getArtist(), 50, 130);


      kFile.update();

      firstLine = "";
      secondLine = "";
      if(kFile.getLatestNoteRow() != null) firstLine = (kFile.getLatestNoteRow().toString());
      if(kFile.getNextNoteRow() != null) secondLine = (kFile.getNextNoteRow().toString());

      canvas.textFont(assets.font_OpenSans);

      canvas.textSize(54);
      canvas.text(firstLine, width/2 - canvas.textWidth(firstLine)/2, height - 150);

      if(!firstLine.equals("")
      && kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement()) != null)
      {
        int dest = -100;

        dest = (int)( width/2 - canvas.textWidth(firstLine)/2
        + canvas.textWidth(kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement(true)))
        + canvas.textWidth(kFile.getLatestSyllable(true))/2);

        if(!kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement(true)).equals("-1"))
        kFile.dot.setDestination(dest);
      } else {
        kFile.dot.setX(-100);
      }

      canvas.textSize(36);
      canvas.text(secondLine, width/2 - canvas.textWidth(secondLine)/2, height - 80);


      canvas.ellipse(kFile.dot.getX(), height-220 - kFile.dot.getY(), 10, 10);

      int bubblePos = (int)( -kFile.currentBeatDouble * kFile.bpm/8);

      canvas.strokeWeight(0);

      // Draw all the notes to be sung
      for(NoteElement e : kFile.getNoteElements()) {
        canvas.fill(220);

        if(e.noteType == NoteElement.NOTE_TYPE_GOLDEN)
          canvas.fill(224,184,134);
        else if(e.noteType == NoteElement.NOTE_TYPE_LINEBREAK)
          continue;

        // If already sung, change appearance
        boolean sungNote = kFile.sung(e);
        if(sungNote)
          canvas.fill(43,221,160);

        canvas.rect(width/2 + bubblePos + e.position * kFile.bpm/8, height/2 - e.pitch * 15, e.duration * kFile.bpm/8, 15, 15);

        // Change note appearance if this is currently being sung (or played)
        if(!sungNote && kFile.singing(e)) {
          canvas.fill(43,221,160);
          canvas.rect(width/2, height/2 - e.pitch * 15, - (float)(kFile.currentBeatDouble - e.position)* kFile.bpm/8, 15, 15);
        }

      }

      // Draw the offsets of notes already sung
      for(SungNoteElement e : notesSung) {
        if(e.getNoteElement().noteType == NoteElement.NOTE_TYPE_LINEBREAK)
          continue;

        canvas.fill(255,100,80, 80);
        canvas.rect(width/2 + bubblePos + (float)e.getCurrentBeatDouble() * kFile.bpm/8, height/2 - (e.getNoteElement().getPitch() - e.getOffset()) * 15, 1 * kFile.bpm/8, 15, 15);
      }

      // Analyze the current note
      if(kFile.hasActiveNote() && millis() - this.lastAnalysed > ANALYZATION_DELAY) {
        float mic1frequency = detector1.getCurrentFrequency();

        NoteElement e = kFile.getLatestNoteElement();

        int currentNote = e.getPitch();
        int currentMidiNormalized = (int)(detector1.normalizeMidi(currentNote));

        float sungMidiNormalized = detector1.frequencyToNormalizedMidi(mic1frequency);

        float offsetRaw[] = { (currentMidiNormalized-12 - sungMidiNormalized), (currentMidiNormalized - sungMidiNormalized), (currentMidiNormalized+12 - sungMidiNormalized) };

        // Add a circular offset (because 12 is nearer to 1 than to 7...)
        float offset = 0;
        if(abs(offsetRaw[0]) <= 5.5) offset = offsetRaw[0];
        else if(abs(offsetRaw[1]) <= 5.5) offset = offsetRaw[1];
        else if(abs(offsetRaw[2]) <= 5.5) offset = offsetRaw[2];

        // Adjust difficulty
        offset *= 0.5;

        canvas.fill(255,100,80);
        canvas.rect(width/2 - 15, height/2 - (currentNote - offset) * 15, 15, 15, 15);

        notesSung.add(new SungNoteElement(e, offset, kFile.getCurrentBeatDouble()));

        this.lastAnalysed = millis();
      }
    }

    canvas.endDraw();
  }

  @Override
  public void stop() {
    this.isRunning = false;
  }

  @Override
  public void keyPressed() {
    if (keyCode == 27) {
      key = 0;
      if(this.isPaused == false) {
        this.movie.pause();
      } else {
        this.movie.play();
      }

      this.isPaused = !this.isPaused;
    }
  }

}
