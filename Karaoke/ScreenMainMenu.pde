class ScreenMainMenu extends Screen {

  private final int COVER_SIZE = 250;
  private final int COVER_SIZE_SELECTED = 500;
  private final int COVER_GAP = 500;

  private Assets assets;

  private String songFolder;
  private ArrayList<KaraokeFile> karaokeFiles;

  private int selectedSong = 0;

  public ScreenMainMenu(Karaoke karaoke) {
    super(karaoke);

    this.assets = this.karaoke.getAssets();
    this.songFolder = this.karaoke.getSettingsManager().getSetting("songFolder");
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

    this.canvas.beginDraw();
    this.canvas.clear();
    this.canvas.background(0);

    // Draw the title
    this.canvas.fill(255);
    this.canvas.textFont(assets.font_QuickSand_Bold);
    this.canvas.textSize(42);
    this.canvas.text("Hauptmenü", 50, 90);

    // Draw the subtitle
    this.canvas.textFont(assets.font_QuickSand);
    this.canvas.textSize(30);
    this.canvas.text("Bitte wähle einen Song", 50, 130);

    // Draw the files
    int item = 0;
    for(KaraokeFile k : karaokeFiles) {

      this.canvas.strokeWeight(2);
      this.canvas.noFill();
      this.canvas.stroke(255);

      int coverX = width/2 - COVER_SIZE/2 + COVER_GAP * (item-selectedSong);

      if(item == selectedSong) {
        coverX = width/2 - COVER_SIZE_SELECTED/2;

        this.canvas.rect(coverX -2, height/2 - COVER_SIZE_SELECTED/2-2, COVER_SIZE_SELECTED+4, COVER_SIZE_SELECTED+4, 5);
        this.canvas.image(k.getCover(), coverX, height/2 - COVER_SIZE_SELECTED/2, COVER_SIZE_SELECTED, COVER_SIZE_SELECTED);

        this.canvas.textFont(assets.font_OpenSans_Bold);
        this.canvas.textSize(30);
        this.canvas.text(k.getTitle(), coverX, height/2 + COVER_SIZE_SELECTED/2 + 60);

        this.canvas.textFont(assets.font_OpenSans);
        this.canvas.textSize(30);
        this.canvas.text(k.getArtist(), coverX, height/2 + COVER_SIZE_SELECTED/2 + 100);
      } else {
        this.canvas.image(k.getCover(), coverX, height/2 - COVER_SIZE/2, COVER_SIZE, COVER_SIZE);
      }

      item++;
    }

    this.canvas.endDraw();
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

  // Loads a song and start the ScreenSingingGame
  // This uses a Thread to show the Loading Screen as long as the ScreenSingingGame is loading
  private void loadSong() {
    new Thread(){
      public void run(){

        karaoke.loadScreen.start();
        karaoke.screenManager.setScreen(karaoke.loadScreen);

        ScreenSingingGame screenSingingGame = new ScreenSingingGame(karaoke, karaokeFiles.get(selectedSong));
        screenSingingGame.start();
        karaoke.screenManager.setScreen(screenSingingGame);

        karaoke.loadScreen.stop();

      }
    }.start();
  }

  // Opens the Settings Menu
  private void openSettings() {
    this.karaoke.settingsScreen.start();
    this.karaoke.screenManager.setScreen(this.karaoke.settingsScreen);
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

    // Open Settings
    if(keyCode == TAB) openSettings();
  }

}
