class KaraokeFile {

  private ArrayList<NoteElement> noteElements;

  float bpm;
  int gap;

  String artist;
  String title;

  private PImage cover;
  private String moviePath;

  long startTime;
  int currentBeat;
  double currentBeatDouble;

  Movie movie;
  Dot dot;

  ArrayList<NoteRow> noteRows;
  private File rawFile;

  public KaraokeFile(String file) {

    this.rawFile = new File(file);

    this.artist = "Unknown Artist";
    this.title = "Unknown Title";

    this.cover = loadImage("assets/unknown.jpg");

    dot = new Dot();


    String[] lines = loadStrings(file);
    noteElements = new ArrayList<NoteElement>();
    noteRows = new ArrayList<NoteRow>();

    for (int i = 0 ; i < lines.length; i++) {
      if(lines[i] == null || lines[i].charAt(0) == 'E') continue;

      if(lines[i].charAt(0) == '#') {

        String[] kv = split(lines[i], ':');
        String key = kv[0];
        String value = kv[1];

        if(key.equals("#BPM")) bpm = Float.valueOf(value.replace(",", "."));
        if(key.equals("#GAP")) gap = Integer.valueOf(value);

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
        String[] elements = splitCommands(lines[i]);

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

          NoteElement noteElement = new NoteElement(noteType, Integer.valueOf(elements[1]), Integer.valueOf(elements[2]), Integer.valueOf(elements[3]), elements[4]);
          noteElements.add(noteElement);
          //print(elements[1] + "|" + elements[2] + "|" + elements[3] + "|" + elements[4] + "\n");

      }
    }

    ArrayList<NoteElement> noteRowElements = new ArrayList<NoteElement>();

    for(NoteElement i : noteElements) {

      if(i.getNoteType() == NoteElement.NOTE_TYPE_LINEBREAK) {
        //println();

        noteRows.add(new NoteRow((ArrayList<NoteElement>)noteRowElements.clone(), i.getPosition()));
        noteRowElements = new ArrayList<NoteElement>();

      } else {
        //print(i.getSyllable());
        //println((new NoteRow((ArrayList<NoteElement>)noteRowElements.clone())).getLine());
        noteRowElements.add(i);

      }

    }

    noteRows.add(new NoteRow((ArrayList<NoteElement>)noteRowElements.clone(), 0));
    noteRowElements = new ArrayList<NoteElement>();

    for(NoteRow r : noteRows) {
      //println(r.getLine());
    }

  }


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

  public void play(Movie movie) {
    //startTime = millis();
    this.movie = movie;
  }

  int lastRow = 0;

  public void update() {
    //long elapsed = (millis() - startTime) - gap;
    long elapsed = (long) (movie.time() * 1000) - gap;

    // You have to multiply the beats by 4 because they use quarter beats
    currentBeatDouble = (((double) ((double)bpm * 4 / 60000) * (double) elapsed));
    currentBeat = (int) (currentBeatDouble);

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

  private boolean singing(NoteElement e) {
    return (currentBeatDouble > e.position && !sung(e));
  }

  private boolean sung(NoteElement e) {
    return (currentBeatDouble > e.position + e.duration);
  }

  // Returns true if there is currently a note to be sung
  private boolean hasActiveNote() {
    NoteElement e = getLatestNoteElement();
    return (e != null && !sung(e) && singing(e) && e.noteType != NoteElement.NOTE_TYPE_LINEBREAK);
  }

  private String getLatestSyllable(boolean offset) {

    NoteElement biggestEl = getLatestNoteElement(offset);

    if(biggestEl != null) return biggestEl.getSyllable();
    return "";

  }

  // This gets the difference between the lowest and the highest note
  private int getPitchRange() {

    int biggestPitch = noteElements.get(0).getPitch();
    int smallestPitch = noteElements.get(0).getPitch();
    for(NoteElement e : noteElements) {
      if(e.getPitch() > biggestPitch) biggestPitch = e.getPitch();
      if(e.getPitch() < smallestPitch) smallestPitch = e.getPitch();
    }

    return abs(biggestPitch - smallestPitch);
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
