class KaraokeFile {

  private ArrayList<NoteElement> noteElements;

  float bpm;
  int gap;

  String artist;
  String title;

  private PImage cover;
  private String moviePath;

  float startTime;
  int currentBeat;
  double currentBeatDouble;

  Movie movie;
  Dot dot;

  ArrayList<NoteRow> noteRows;
  private File rawFile;

  public KaraokeFile(String file) {

    this.rawFile = new File(file);

    // Instanciate Settings with some placeholders if they are undefined

    this.artist = "Unknown Artist";
    this.title = "Unknown Title";

    this.startTime = 0;

    this.cover = loadImage("assets/unknown.jpg");

    dot = new Dot();

    // Load the karaoke file
    String[] lines = loadStrings(file);

    noteElements = new ArrayList<NoteElement>();
    noteRows = new ArrayList<NoteRow>();

    // loop through every line of the karaoke file
    for (int i = 0 ; i < lines.length; i++) {
      if(lines[i] == null || lines[i].charAt(0) == 'E') continue;

      // Settings are declared with a '#' and their value is delimited by ':'
      if(lines[i].charAt(0) == '#') {

        String[] kv = split(lines[i], ':');
        String key = kv[0];
        String value = kv[1];

        // Store recognized settings

        if(key.equals("#BPM")) bpm = Float.valueOf(value.replace(",", "."));
        if(key.equals("#GAP")) gap = Integer.valueOf(value);
        if(key.equals("#START")) this.startTime = Float.valueOf(value);

        if(key.equals("#ARTIST")) artist = (value);
        if(key.equals("#TITLE")) title = (value);

        if(key.equals("#COVER")) {
          String coverLocation = rawFile.getParent() + "\\" + (value);
          cover = loadImage(coverLocation);
        }

        if(key.equals("#VIDEO")) {
          this.moviePath = rawFile.getParent() + "\\" + (value);
        }

      } else {
        // Otherwise the current row is a NoteElement

        String[] elements = splitCommands(lines[i]);

        // Determine its type ...
        int noteType = NoteElement.NOTE_TYPE_REGULAR;

        switch(elements[0].charAt(0)) {
          case ':':
            noteType = NoteElement.NOTE_TYPE_REGULAR;
            break;
          case '*':
            noteType = NoteElement.NOTE_TYPE_GOLDEN;
            break;
          case 'F':
            noteType = NoteElement.NOTE_TYPE_FREESTYLE;
            break;
          case '-':
            noteType = NoteElement.NOTE_TYPE_LINEBREAK;
            break;

        }

        // ... and store them in the ArrayList
        NoteElement noteElement = new NoteElement(noteType, Integer.valueOf(elements[1]), Integer.valueOf(elements[2]), Integer.valueOf(elements[3]), elements[4]);
        noteElements.add(noteElement);

      }
    }

    // Prepare Note Rows
    ArrayList<NoteElement> noteRowElements = new ArrayList<NoteElement>();

    // Go through every NoteElement ...
    for(NoteElement i : noteElements) {

      if(i.getNoteType() == NoteElement.NOTE_TYPE_LINEBREAK) {
        // ... if there is a linebreak, store every note element since the last linebreak in a NoteRow
        // and add them to the ArrayList
        noteRows.add(new NoteRow((ArrayList<NoteElement>)noteRowElements.clone(), i.getPosition()));

        // Clear the list for the next lines
        noteRowElements = new ArrayList<NoteElement>();

      } else {
        // ... if it's an actual note, add it to the current NoteRow
        noteRowElements.add(i);
      }

    }

    // Store the last row (because there is no linebreak in the end)
    noteRows.add(new NoteRow((ArrayList<NoteElement>)noteRowElements.clone(), 0));

    // Clear the list
    noteRowElements = null;

  }

  // This splits a line from a karaoke file into its parts
  public String[] splitCommands(String command) {
    char cmd[] = command.toCharArray();
    String r[] = {"", "", "", "", ""};
    int spaceCount = 0;

    for(int i=0; i<cmd.length; i++) {
      if(spaceCount < 4) {

        if(cmd[i] == ' ') spaceCount++;
        else r[spaceCount] += cmd[i];

      } else {
        r[4] += cmd[i];
      }
    }

    // override defaults:
     if(r[0].equals("")) r[0] = ":";
     if(r[1].equals("")) r[1] = "0";
     if(r[2].equals("")) r[2] = "0";
     if(r[3].equals("")) r[3] = "0";

    return r;

  }

  // The KaraokeFile time depends on the movie time, so you have to set a movie here
  public void play(Movie movie) {
    this.movie = movie;

    // If there is a setting to start at another point in the song, jump to it
    if(this.startTime > 0) {
      this.movie.pause();
      this.movie.jump(this.startTime);
      this.movie.play();
    }

  }

  public void update() {
    // Calculate the elapsed time based on the movie time
    long elapsed = (long) (movie.time() * 1000) - gap;

    // You have to multiply the beats by 4 because they use quarter beats in the karaoke files
    currentBeatDouble = (((double) ((double)bpm * 4 / 60000) * (double) elapsed));
    currentBeat = (int) (currentBeatDouble);

    // Update the dot
    dot.update();

  }

  public NoteRow getLatestNoteRow() { return getLatestNoteRow(false); }

  public NoteRow getLatestNoteRow(boolean offset) {

    int biggest = -200;
    NoteRow biggestRow = null;

    long elapsed = (long) (movie.time() * 1000) - gap;
    long elapsedOffset = elapsed + Dot.TIME;
    int cb = (!offset) ? currentBeat : (int)(((double) ((double)bpm * 4 / 60000) * (double) elapsedOffset));

    for(NoteRow r : noteRows) {
      if(r.getFirstBeat() < cb && r.getFirstBeat() >= biggest && cb < r.getEndBeat()) {
        biggest = r.getFirstBeat();
        biggestRow = r;
      }

    }


    return biggestRow;

  }

  public NoteRow getNextNoteRow() {

    int biggest = -200;
    NoteRow biggestRow = null;

    long elapsed = (long) (movie.time() * 1000) - gap;
    long elapsedOffset = elapsed + Dot.TIME;

    for(NoteRow r : noteRows) {
      if(r.getFirstBeat() < currentBeat && r.getFirstBeat() >= biggest) {
        biggest = r.getFirstBeat();
        biggestRow = r;
      }
    }

    if(biggestRow != null) {
      int index = noteRows.indexOf(biggestRow);
      if(index+1 < noteRows.size() && noteRows.get(index+1) != null) return noteRows.get(index+1);
      else return null;
    }
    return noteRows.get(0);
  }

  private NoteElement getLatestNoteElement() {
    return getLatestNoteElement(false);
  }

  private NoteElement getLatestNoteElement(boolean offset) {

    int biggest = -200;
    NoteElement biggestEl = null;

    long elapsed = (long) (movie.time() * 1000) - gap;
    long elapsedOffset = elapsed + Dot.TIME;
    int cb = (!offset) ? currentBeat : (int)(((double) ((double)bpm * 4 / 60000) * (double) elapsedOffset));

    for(NoteElement n : noteElements) {
      int pos = n.getPosition();
      if(pos <= cb && pos > biggest)  {
        biggestEl = n;
        biggest = pos;
      }
    }

    if(biggestEl != null) return biggestEl;
    return null;

  }

  // Returns true if NoteElement e is the NoteElement which you should sing at this moment
  private boolean singing(NoteElement e) {
    return (currentBeatDouble > e.position && !sung(e));
  }

  // Returns true if the NoteElement is already been sung
  private boolean sung(NoteElement e) {
    return (currentBeatDouble > e.position + e.duration);
  }

  // Returns true if there is currently a note to be sung
  private boolean hasActiveNote() {
    NoteElement e = getLatestNoteElement();
    return (e != null && !sung(e) && singing(e) && e.noteType != NoteElement.NOTE_TYPE_LINEBREAK);
  }

  // Returns the current syllable to be sung
  private String getLatestSyllable(boolean offset) {

    NoteElement biggestEl = getLatestNoteElement(offset);

    if(biggestEl != null) return biggestEl.getSyllable();
    return "";

  }

  // This gets the difference between the lowest and the highest note
  public int getPitchRange(ArrayList<NoteElement> noteElements) {

    int biggestPitch = noteElements.get(0).getPitch();
    int smallestPitch = noteElements.get(0).getPitch();
    for(NoteElement e : noteElements) {
      if(e.getPitch() > biggestPitch) biggestPitch = e.getPitch();
      if(e.getPitch() < smallestPitch) smallestPitch = e.getPitch();
    }

    return abs(biggestPitch - smallestPitch);
  }

  // This gets the average pitch height
  public int getPitchAverage(ArrayList<NoteElement> noteElements) {

    int pitches = 0;

    for(NoteElement e : noteElements) {
      pitches += e.getPitch();
    }

    return (int)(pitches / noteElements.size());
  }

  public int getPitchRange() {
    return getPitchRange(this.noteElements);
  }

  private String getLatestSyllable() {
    return getLatestSyllable(false);
  }

  public String getTitle() {
    return this.title;
  }

  public String getArtist() {
    return this.artist;
  }

  public ArrayList<NoteElement> getNoteElements() {
    return this.noteElements;
  }

  public int getCurrentBeat() {
    return this.currentBeat;
  }

  public double getCurrentBeatDouble() {
    return this.currentBeatDouble;
  }

  public PImage getCover() {
    return this.cover;
  }

  public String getMoviePath() {
    return this.moviePath;
  }

}
