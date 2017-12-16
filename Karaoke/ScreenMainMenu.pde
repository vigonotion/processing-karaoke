class ScreenMainMenu extends Screen {

  private final int COVER_SIZE = 250;
  private final int COVER_SIZE_SELECTED = 500;
  private final int COVER_GAP = 650;

  private Assets assets;

  private String songFolder = "C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\";
  private ArrayList<KaraokeFile> karaokeFiles;

  private int selectedSong = 0;

  public ScreenMainMenu(Karaoke karaoke) {
    super(karaoke);

    this.assets = this.karaoke.getAssets();
    this.karaokeFiles = new ArrayList<KaraokeFile>();
    listSongs();
  }

  @Override
  public void start() {
    this.isRunning = true;
  }

  @Override
  public void draw() {
    if(!isRunning) return;

    canvas.beginDraw();
    canvas.clear();
    canvas.background(0);

    // Draw the title
    canvas.fill(255);
    canvas.textFont(assets.font_QuickSand_Bold);
    canvas.textSize(42);
    canvas.text("Hauptmenü", 50, 90);

    // Draw the subtitle
    canvas.textFont(assets.font_QuickSand);
    canvas.textSize(30);
    canvas.text("Bitte wähle einen Song", 50, 130);

    // Draw the files
    int item = 0;
    for(KaraokeFile k : karaokeFiles) {

      // Background Rect
      // canvas.rect(50, height/2 -300, 1300, 700, 5);

      canvas.strokeWeight(2);
      canvas.noFill();
      canvas.stroke(255);

      int coverX = width/2 - COVER_SIZE/2 + COVER_GAP * (item-selectedSong);

      if(item == selectedSong) {
        coverX = width/2 - COVER_SIZE_SELECTED/2;

        canvas.rect(coverX -2, height/2 - COVER_SIZE_SELECTED/2-2, COVER_SIZE_SELECTED+4, COVER_SIZE_SELECTED+4, 5);
        canvas.image(k.getCover(), coverX, height/2 - COVER_SIZE_SELECTED/2, COVER_SIZE_SELECTED, COVER_SIZE_SELECTED);

        canvas.textFont(assets.font_OpenSans_Bold);
        canvas.textSize(30);
        canvas.text(k.getTitle(), coverX, height/2 + COVER_SIZE_SELECTED/2 + 60);

        canvas.textFont(assets.font_OpenSans);
        canvas.textSize(30);
        canvas.text(k.getArtist(), coverX, height/2 + COVER_SIZE_SELECTED/2 + 100);
      } else {
        canvas.image(k.getCover(), coverX, height/2 - COVER_SIZE/2, COVER_SIZE, COVER_SIZE);
      }

      item++;
    }

    canvas.endDraw();
  }

  private void listSongs() {
    File[] files = getFiles(songFolder);
    if(files != null) {

      for (int i = 0; i < files.length; i++) {
        File f = files[i];
        String cFileName = f.getName();
        if((cFileName.substring(cFileName.length() - 3, cFileName.length())).equals("txt")) {
          // Load the KaraokeFile
          karaokeFiles.add(new KaraokeFile(f.getAbsolutePath()));
        }
      }

    } else {
      println("[ERROR]: songFolder is not a directory");
    }
  }

  private File[] getFiles(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      File[] files = file.listFiles();
      return files;
    } else {
      // If it's not a directory
      return null;
    }
  }

  private void loadSong() {
    println("Loading song " + selectedSong);

    this.karaoke.loadGameThread(karaokeFiles.get(selectedSong));
  }

  @Override
  public void stop() {

  }

  @Override
  public void keyPressed() {
    // Song Navigation
    if(keyCode == RIGHT) selectedSong++;
    else if(keyCode == LEFT) selectedSong--;
    selectedSong = constrain(selectedSong, 0, karaokeFiles.size()-1);

    // Select a song
    if(keyCode == ENTER) loadSong();
  }

}
