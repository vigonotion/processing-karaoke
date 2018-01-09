private Assets assets;
private SettingsManager settingsManager;
private AudioManager audioManager;

private ScreenManager screenManager;

// Declare Screens which should be only instanciated once
public ScreenLoadGame loadScreen;
public ScreenMainMenu mainMenu;
public ScreenSettings settingsScreen;


void settings() {
  // Create Settings Manager
  settingsManager = new SettingsManager("data/assets/settings.ini");

  // Window Settings, P2D as Renderer (faster)
  if(getSettingsManager().getBooleanSetting("fullScreen")) {
    fullScreen(P2D, getSettingsManager().getIntegerSetting("monitor"));
  } else {
    size(getSettingsManager().getIntegerSetting("width"), getSettingsManager().getIntegerSetting("height"), P2D);
  }
}

void setup() {

  // Set the framerate
  // (This does not work in Processings settings()-method)
  frameRate(getSettingsManager().getIntegerSetting("frameRate"));

  // Create Assets class
  assets = new Assets();
  assets.init();

  // Create Audio Manager
  audioManager = new AudioManager(this);

  // Create Screen Manager
  screenManager = new ScreenManager(this);

  // Instanciate Screens
  loadScreen = new ScreenLoadGame(this);
  mainMenu = new ScreenMainMenu(this);
  settingsScreen = new ScreenSettings(this);

  // Set the current screen to Main Menu
  screenManager.setScreen(mainMenu);

}

void draw() {

  // This draws the ScreenManager which manages the Screen to be drawn
  screenManager.draw();
  image(screenManager.getScreen(), 0, 0);

}

// Allow other classes to use main assets
public Assets getAssets() {
  return this.assets;
}

// Allow other classes to use settings manager
public SettingsManager getSettingsManager() {
  return this.settingsManager;
}

// Allow other classes to use audio manager
public AudioManager getAudioManager() {
  return this.audioManager;
}


// Let the ScreenManager handle Input Events

void keyPressed() {
  screenManager.keyPressed();
}

void keyReleased() {
  screenManager.keyReleased();
}

void mousePressed() {
  screenManager.mousePressed();
}

void mouseReleased() {
  screenManager.mouseReleased();
}
