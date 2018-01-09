import processing.video.*;

public class ScreenSingingGame extends Screen {

  // HARD CODED SETTINGS
  private final long ANALYZATION_DELAY = 20;
  private final int NOTE_OFFSET = 100;
  private final int NOTE_HEIGHT = 10;
  private final int MULTIPLAYER_GAP = 200;

  private final boolean DEBUG_GUI = false;

  // ADJUSTABLE ONE-TIME SETTINGS
  private final boolean isMultiplayer;

  private boolean isPaused;
  private int selectedIndex = 0;

  private Assets assets;

  private Movie movie;
  private KaraokeFile kFile;

  private String firstLine = "";
  private String secondLine = "";

  private Player player1;
  private Player player2;

  private ScoreBar scoreBar;

  private long lastAnalysed;
  private int vOffset;
  private int pitchAv;

  public ScreenSingingGame(Karaoke karaoke, KaraokeFile kFile) {
    super(karaoke);

    this.assets = this.karaoke.getAssets();

    this.kFile = kFile;

    this.isMultiplayer = this.karaoke.getSettingsManager().getBooleanSetting("multiplayer");

    this.movie = new Movie(this.karaoke, kFile.getMoviePath());
    this.movie.frameRate(24);

    this.player1 = new Player(this.karaoke, this.karaoke.getAudioManager().getAudioInput(1), color(43,221,160));
    if(isMultiplayer) this.player2 = new Player(this.karaoke, this.karaoke.getAudioManager().getAudioInput(2), color(230,0,126));

    if(isMultiplayer) this.scoreBar = new ScoreBar(this.karaoke, this.player1, this.player2);

    this.lastAnalysed = millis();

  }

  @Override
  public void start() {
    this.player1.start();
    if(isMultiplayer) this.player2.start();

    this.movie.play();

    this.kFile.play(movie);
    this.kFile.dot.play();

    this.isRunning = true;
    this.isPaused = false;
  }

  @Override
  public void draw() {

    if(!isRunning) return;

    this.canvas.beginDraw();
    this.canvas.clear();

    if(movie.available()) {
      movie.read();
    }

    this.canvas.tint(50);
    this.canvas.image(movie, 0, 0, width, height);

    this.canvas.textAlign(LEFT);
    this.canvas.noTint();

    // Show the Pause Screen
    if(isPaused) {

      // Draw the title
      this.canvas.fill(255);
      this.canvas.textFont(assets.font_QuickSand_Bold);
      this.canvas.textSize(42);
      this.canvas.text("Spiel pausiert", 50, 90);

      this.canvas.textFont(assets.font_QuickSand);
      this.canvas.textSize(30);
      this.canvas.text(kFile.getArtist() + " - " + kFile.getTitle(), 50, 130);

      // And the subtitle
      this.canvas.textFont(assets.font_OpenSans);
      this.canvas.textSize(42);
      this.canvas.textAlign(CENTER, CENTER);
      this.canvas.text("FORTSETZEN", width/2, height/2 - 100);
      this.canvas.text("HAUPTMENÜ", width/2, height/2 + 100);

      this.canvas.strokeWeight(2);
      this.canvas.noFill();
      this.canvas.stroke(255);

      this.canvas.rectMode(CENTER);

      // Draw a rect around the selected item
      if(selectedIndex == 0) this.canvas.rect(width/2, height/2 - 100 + 10, 400, 100, 5);
      else this.canvas.rect(width/2, height/2 + 100 + 10, 400, 100, 5);


    }

    // Or show the Game Screen
    else {

      // If the movie is finished, show results
      if (this.movie.time() == this.movie.duration()) {
        results();
      }

      // Draw the title
      this.canvas.textAlign(LEFT);
      this.canvas.fill(255);
      this.canvas.textFont(assets.font_QuickSand_Bold);
      this.canvas.textSize(42);
      this.canvas.text(kFile.getTitle(), 50, 90);

      // Draw the subtitle
      this.canvas.textFont(assets.font_QuickSand);
      this.canvas.textSize(30);
      this.canvas.text(kFile.getArtist(), 50, 130);

      // Draw the score bar
      if(isMultiplayer) scoreBar.draw(this.canvas, width/2 - scoreBar.getCanvasWidth()/2, 60);

      // Update the Karaoke File (syncs everything to movie time)
      kFile.update();

      // Clear lyrics lines...
      firstLine = "";
      secondLine = "";

      // and fill them if new data is available
      if(kFile.getLatestNoteRow() != null) firstLine = (kFile.getLatestNoteRow().toString());
      if(kFile.getNextNoteRow() != null) secondLine = (kFile.getNextNoteRow().toString());

      // Draw the first line
      this.canvas.textAlign(LEFT);
      this.canvas.textFont(assets.font_OpenSans);
      this.canvas.textSize(54);
      this.canvas.text(firstLine, width/2 - this.canvas.textWidth(firstLine)/2, height - 150);

      // Set the new position for the dot
      if(!firstLine.equals("")
      && kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement()) != null)
      {
        int dest = -100;

        dest = (int)( width/2 - this.canvas.textWidth(firstLine)/2
        + this.canvas.textWidth(kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement(true)))
        + this.canvas.textWidth(kFile.getLatestSyllable(true))/2);

        if(!kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement(true)).equals("-1"))
        kFile.dot.setDestination(dest);
      } else {
        kFile.dot.setX(-100);
      }

      // Draw dot
      this.canvas.ellipse(kFile.dot.getX(), height-220 - kFile.dot.getY(), 10, 10);

      // Draw the second lyrics line
      this.canvas.textSize(36);
      this.canvas.text(secondLine, width/2 - this.canvas.textWidth(secondLine)/2, height - 80);

      // Draw notes
      NoteRow row = kFile.getLatestNoteRow();

      if(!firstLine.equals("")
      && row != null) {

        // Calculate the vertical offset to align notes in center
        this.vOffset = int((kFile.getPitchRange(row.getNoteElements()) * NOTE_HEIGHT)) + MULTIPLAYER_GAP;
        this.pitchAv = kFile.getPitchAverage(row.getNoteElements());

        // Show some debug boxes if desired
        if(DEBUG_GUI) {
          int offset = int((kFile.getPitchRange(row.getNoteElements()) * NOTE_HEIGHT));
          this.canvas.noFill();
          this.canvas.stroke(0,0,255);
          this.canvas.strokeWeight(1);

          this.canvas.line(0, height/2, width, height/2);

          this.canvas.line(0, height/2 +0, width, height/2 +0);
          this.canvas.line(0, height/2 +0, width, height/2 +0);

          this.canvas.stroke(255,0,0);
          this.canvas.rect(NOTE_OFFSET, height/2 - offset/2 - vOffset/2, width-(2*NOTE_OFFSET), offset);
          this.canvas.rect(NOTE_OFFSET, height/2 - offset/2 + vOffset/2, width-(2*NOTE_OFFSET), offset);
        }


        for(NoteElement e : row.getNoteElements()) {

          this.canvas.fill(220);
          this.canvas.strokeWeight(0);

          if(e.noteType == NoteElement.NOTE_TYPE_GOLDEN) this.canvas.fill(224,184,134);

          // If already sung, change appearance
          boolean sungNote = kFile.sung(e);

          if(isMultiplayer) {

            // Freestyle notes only have outlines as they do not give points
            if(e.noteType == NoteElement.NOTE_TYPE_FREESTYLE) {
              this.canvas.strokeWeight(2);
              this.canvas.stroke(220);
              this.canvas.noFill();
            }

            // Draw Player 1's Note
            if(sungNote) this.canvas.fill(player1.getNoteColor());
            this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 - vOffset/2 - (e.getPitch() - this.pitchAv) * NOTE_HEIGHT, (width - 2*NOTE_OFFSET) * ((float)e.duration / (float)(row.getDuration())), NOTE_HEIGHT, NOTE_HEIGHT);

            // Draw Player 2's Note
            if(sungNote) this.canvas.fill(player2.getNoteColor());
            this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 + vOffset/2 - (e.getPitch() - this.pitchAv) * NOTE_HEIGHT, (width - 2*NOTE_OFFSET) * ((float)e.duration / (float)(row.getDuration())), NOTE_HEIGHT, NOTE_HEIGHT);

            // If the note is currently being sung, draw that part of the note
            if(!sungNote && kFile.singing(e)) {
              this.canvas.fill(player1.getNoteColor());
              this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 - vOffset/2 - (e.getPitch() - this.pitchAv) * NOTE_HEIGHT, ((float)(kFile.currentBeatDouble - e.getPosition())/ (float)(row.getDuration()))* (width - 2*NOTE_OFFSET), NOTE_HEIGHT, NOTE_HEIGHT);

              this.canvas.fill(player2.getNoteColor());
              this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 + vOffset/2 - (e.getPitch() - this.pitchAv) * NOTE_HEIGHT, ((float)(kFile.currentBeatDouble - e.getPosition())/ (float)(row.getDuration()))* (width - 2*NOTE_OFFSET), NOTE_HEIGHT, NOTE_HEIGHT);
            }

          } else {
            // Draw the current note
            if(sungNote) this.canvas.fill(player1.getNoteColor());
            this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 - (e.getPitch() - this.pitchAv) * NOTE_HEIGHT, (width - 2*NOTE_OFFSET) * ((float)e.duration / (float)(row.getDuration())), NOTE_HEIGHT, NOTE_HEIGHT);

            // If the note is currently being sung, draw that part of the note
            if(!sungNote && kFile.singing(e)) {
              this.canvas.fill(player1.getNoteColor());
              this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 - (e.getPitch() - this.pitchAv) * NOTE_HEIGHT, ((float)(kFile.currentBeatDouble - e.getPosition())/ (float)(row.getDuration()))* (width - 2*NOTE_OFFSET), NOTE_HEIGHT, NOTE_HEIGHT);
            }
          }

        }

        // Draw the notes which have been sung (Player 1)
        for(SungNoteElement e : player1.notesSung) {

          // Skip this if the Note is a Linebreak or freestyle
          if(e.getNoteElement().noteType == NoteElement.NOTE_TYPE_LINEBREAK || e.getNoteElement().noteType == NoteElement.NOTE_TYPE_FREESTYLE)
            continue;

          // Adds alpha to the color
          //
          // Processing 1.0 - Processing Discourse - Set the alpha of a color variable? by Casey Fry
          // Retrieved 23:48, January 4, 2018, https://processing.org/discourse/beta/num_1261125421.html
          this.canvas.fill((player1.getNoteColor() & 0xffffff) | (80 << 24));

          if(isMultiplayer)
            this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 - vOffset/2 - (e.getNoteElement().getPitch() - this.pitchAv - e.getOffset()) * NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT); //old width: (width - 2*NOTE_OFFSET) * (1f / (float)(row.getDuration()))
          else
            this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 - (e.getNoteElement().getPitch() - this.pitchAv - e.getOffset()) * NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT); //old width: (width - 2*NOTE_OFFSET) * (1f / (float)(row.getDuration()))

        }

        // ...Player 2
        if(isMultiplayer)
        for(SungNoteElement e : player2.notesSung) {
          if(e.getNoteElement().noteType == NoteElement.NOTE_TYPE_LINEBREAK || e.getNoteElement().noteType == NoteElement.NOTE_TYPE_FREESTYLE)
            continue;

            // Adds alpha to the color
            //
            // Processing 1.0 - Processing Discourse - Set the alpha of a color variable? by Casey Fry
            // Retrieved 23:48, January 4, 2018, https://processing.org/discourse/beta/num_1261125421.html
            this.canvas.fill((player2.getNoteColor() & 0xffffff) | (80 << 24));

          this.canvas.rect(NOTE_OFFSET + (width - 2*NOTE_OFFSET) * ((float)(e.getPosition() - row.getFirstBeat()) / (float)(row.getDuration())), height/2 + vOffset/2 - (e.getNoteElement().getPitch() - this.pitchAv - e.getOffset()) * NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT, NOTE_HEIGHT); //old width: (width - 2*NOTE_OFFSET) * (1f / (float)(row.getDuration()))
        }

        // Analyze the current note
        if(kFile.hasActiveNote() && millis() - this.lastAnalysed > ANALYZATION_DELAY) {

          NoteElement e = kFile.getLatestNoteElement();
          if(e.getNoteType() != NoteElement.NOTE_TYPE_LINEBREAK && e.getNoteType() != NoteElement.NOTE_TYPE_FREESTYLE) {

            float mic1frequency = 0, mic2frequency = 0;
            float mic1volume = 0, mic2volume = 0;

            player1.getDetector().analyze();
            mic1frequency = player1.getDetector().getFrequency();
            mic1volume = player1.getDetector().getVolume();

            if(isMultiplayer) {
              player2.getDetector().analyze();
              mic2frequency = player2.getDetector().getFrequency();
              mic2volume = player2.getDetector().getVolume();
            }

            float offset1 = 0, offset2 = 0;

            offset1 = player1.getOffset(e.getPitch(), mic1frequency);
            if(isMultiplayer) offset2 = player2.getOffset(e.getPitch(), mic2frequency);

            // Adjust difficulty (smaller means easier)
            offset1 *= 0.5;
            offset2 *= 0.5;

            // Add sung note to list (only if there really was input on the microphone, checked by volume)
            if(mic1volume > this.karaoke.getSettingsManager().getDoubleSetting("volume1"))
            player1.notesSung.add(new SungNoteElement(e, offset1, kFile.getCurrentBeatDouble()));

            if(isMultiplayer && mic2volume > this.karaoke.getSettingsManager().getDoubleSetting("volume2"))
            player2.notesSung.add(new SungNoteElement(e, offset2, kFile.getCurrentBeatDouble()));

            this.lastAnalysed = millis();
          }
        }

      }


    }

    this.canvas.endDraw();
  }

  // Show the results
  private void results() {
    // Create a new screen for that
    ScreenResults screenResults = new ScreenResults(this.karaoke, this.player1, this.player2, this.isMultiplayer);
    screenResults.start();

    // And switch to that screen
    this.karaoke.screenManager.setScreen(screenResults);

    // Stop this screen
    this.stop();
  }

  @Override
  public void stop() {
    this.isPaused = true;
    this.isRunning = false;
    this.movie.stop();
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

    // Move through pause menu items
    if(keyCode == DOWN) selectedIndex++;
    else if(keyCode == UP) selectedIndex--;
    selectedIndex %= 2;

    // On pause screen, do the action for the selected item
    if(keyCode == ENTER && this.isPaused) {

      // Continue
      if(selectedIndex == 0) {
        this.isPaused = false;
        this.movie.play();
      }

      // Return to Main Menu
      else {
        this.karaoke.mainMenu.start();
        this.karaoke.screenManager.setScreen(this.karaoke.mainMenu);
        this.stop();
      }

    }

    // Jump straight to results when pressing [enter]
    if(keyCode == ENTER && !this.isPaused) {
      results();
    }

  }

}
