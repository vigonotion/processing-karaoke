import processing.video.*;

public class ScreenSingingGame extends Screen {

  private final long ANALYZATION_DELAY = 20;
  private final int NOTE_OFFSET = 100;
  private final int NOTE_HEIGHT = 10;
  private final int MULTIPLAYER_GAP = 200;

  private boolean isPaused;
  private int selectedIndex = 0;

  private Assets assets;

  private Movie movie;
  private KaraokeFile kFile;

  private String firstLine = "";
  private String secondLine = "";

  private Player player1;

  private long lastAnalysed;
  private int vOffset;

  public ScreenSingingGame(Karaoke karaoke, KaraokeFile kFile) {
    super(karaoke);

    this.assets = this.karaoke.getAssets();

    this.kFile = kFile;

    this.movie = new Movie(this.karaoke, kFile.getMoviePath());
    this.movie.frameRate(24);

    this.player1 = new Player(this.karaoke, new AudioIn(this.karaoke, 1));

    this.lastAnalysed = millis();

    // Calculate the vertical offset to align notes in center
    this.vOffset = int((kFile.getPitchRange() * NOTE_HEIGHT) / 2);
  }

  @Override
  public void start() {
    this.isRunning = true;
    this.isPaused = false;
    this.movie.play();
    this.kFile.play(movie);
    this.kFile.dot.play();
    this.player1.start();
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
    canvas.textAlign(LEFT);

    // Show the Pause Screen
    if(isPaused) {
      canvas.fill(255);
      canvas.textFont(assets.font_QuickSand_Bold);
      canvas.textSize(42);
      canvas.text("Spiel pausiert", 50, 90);

      canvas.textFont(assets.font_QuickSand);
      canvas.textSize(30);
      canvas.text(kFile.getArtist() + " - " + kFile.getTitle(), 50, 130);

      canvas.textFont(assets.font_OpenSans);
      canvas.textSize(42);
      canvas.textAlign(CENTER, CENTER);
      canvas.text("FORTSETZEN", width/2, height/2 - 100);
      canvas.text("HAUPTMENÜ", width/2, height/2 + 100);

      canvas.strokeWeight(2);
      canvas.noFill();
      canvas.stroke(255);

      canvas.rectMode(CENTER);
      if(selectedIndex == 0) canvas.rect(width/2, height/2 - 100 + 10, 400, 100, 5);
      else canvas.rect(width/2, height/2 + 100 + 10, 400, 100, 5);


    }

    // Or show the Game Screen
    else {

      // Draw the title
      canvas.fill(255);
      canvas.textFont(assets.font_QuickSand_Bold);
      canvas.textSize(42);
      canvas.text(kFile.getTitle(), 50, 90);

      // Draw the subtitle
      canvas.textFont(assets.font_QuickSand);
      canvas.textSize(30);
      canvas.text(kFile.getArtist(), 50, 130);

      // Update the Karaoke File (syncs everything to movie time)
      kFile.update();

      // Clear lyrics lines...
      firstLine = "";
      secondLine = "";

      // and fill them if new data is available
      if(kFile.getLatestNoteRow() != null) firstLine = (kFile.getLatestNoteRow().toString());
      if(kFile.getNextNoteRow() != null) secondLine = (kFile.getNextNoteRow().toString());

      // Draw the first line
      canvas.textFont(assets.font_OpenSans);
      canvas.textSize(54);
      canvas.text(firstLine, width/2 - canvas.textWidth(firstLine)/2, height - 150);

      // Set the new position for the dot
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

      // Draw dot
      canvas.ellipse(kFile.dot.getX(), height-220 - kFile.dot.getY(), 10, 10);

      // Draw the second lyrics line
      canvas.textSize(36);
      canvas.text(secondLine, width/2 - canvas.textWidth(secondLine)/2, height - 80);

      // Draw notes
      int bubblePos = 0;

      NoteRow row = kFile.getLatestNoteRow();

      if(!firstLine.equals("")
      && row != null) {

        for(NoteElement e : row.getNoteElements()) {

          canvas.fill(220);
          canvas.strokeWeight(0);

          if(e.noteType == NoteElement.NOTE_TYPE_GOLDEN)
            canvas.fill(224,184,134);
          else if(e.noteType == NoteElement.NOTE_TYPE_LINEBREAK)
            continue;

          // If already sung, change appearance
          boolean sungNote = kFile.sung(e);
          if(sungNote)
            canvas.fill(43,221,160);

          canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 + vOffset - e.pitch * NOTE_HEIGHT, (width - 2*NOTE_OFFSET) * ((float)e.duration / (float)(row.getDuration())), NOTE_HEIGHT, NOTE_HEIGHT);

          // Change note appearance if this is currently being sung (or played)
          if(!sungNote && kFile.singing(e)) {
            canvas.fill(43,221,160);
            // @TODO: this currently draws from the middle?
            canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 + vOffset - e.pitch * NOTE_HEIGHT, ((float)(kFile.currentBeatDouble - e.getPosition())/ (float)(row.getDuration()))* (width - 2*NOTE_OFFSET), NOTE_HEIGHT, NOTE_HEIGHT);
          }

        }

        // Draw the notes which have been sung
        for(SungNoteElement e : player1.notesSung) {
          if(e.getNoteElement().noteType == NoteElement.NOTE_TYPE_LINEBREAK)
            continue;

          canvas.fill(255,100,80, 80);
          canvas.fill(43,221,160, 80);
          canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 + vOffset - (e.getNoteElement().getPitch() - e.getOffset()) * NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT); //old width: (width - 2*NOTE_OFFSET) * (1f / (float)(row.getDuration()))
        }

        // Analyze the current note
        if(kFile.hasActiveNote() && millis() - this.lastAnalysed > ANALYZATION_DELAY) {

          player1.getDetector().analyze();
          float mic1frequency = player1.getDetector().getFrequency();
          float mic1volume = player1.getDetector().getVolume();

          NoteElement e = kFile.getLatestNoteElement();

          int currentNote = e.getPitch();
          int currentMidiNormalized = (int)(player1.getDetector().normalizeMidi(currentNote));

          float sungMidiNormalized = player1.getDetector().frequencyToNormalizedMidi(mic1frequency);

          float offsetRaw[] = { (currentMidiNormalized-12 - sungMidiNormalized), (currentMidiNormalized - sungMidiNormalized), (currentMidiNormalized+12 - sungMidiNormalized) };

          // Add a circular offset (because 12 is nearer to 1 than to 7...)
          float offset = 0;
          if(abs(offsetRaw[0]) <= 5.5) offset = offsetRaw[0];
          else if(abs(offsetRaw[1]) <= 5.5) offset = offsetRaw[1];
          else if(abs(offsetRaw[2]) <= 5.5) offset = offsetRaw[2];

          // Adjust difficulty
          offset *= 0.5;

          // Add sung note to list (only if there really was input on the microphone, checked by volume)
          if(mic1volume > 0.005f)
          player1.notesSung.add(new SungNoteElement(e, offset, kFile.getCurrentBeatDouble()));

          this.lastAnalysed = millis();
        }

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
    // Detect if [esc] key is pressed
    if (keyCode == 27) {
      key = 0;
      if(this.isPaused == false) {
        this.movie.pause(); // and pause game
      } else {
        this.movie.play(); // or continue game
      }

      this.isPaused = !this.isPaused;
    }

    if(keyCode == DOWN) selectedIndex++;
    else if(keyCode == UP) selectedIndex--;
    selectedIndex %= 2;

    if(keyCode == ENTER && this.isPaused) {

      // FORTSETZEN
      if(selectedIndex == 0) {
        this.isPaused = false;
        this.movie.play();
      }

      // HAUPTMENÜ
      else {
        ScreenMainMenu screen = new ScreenMainMenu(karaoke);
        screen.start();
        karaoke.screenManager.setScreen(screen);
        this.stop();
      }

    }
  }

}
