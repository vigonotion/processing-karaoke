private Assets assets;
private SettingsManager settingsManager;
private AudioManager audioManager;

private ScreenManager screenManager;
private ScreenSingingGame screenSingingGame;

private ScreenLoadGame loadScreen;

boolean gameLoaded = false;


void settings() {
  // Create Settings Manager
  settingsManager = new SettingsManager("assets/settings.ini");

  // Window Settings, P2D as Renderer (faster)
  if(getSettingsManager().getBooleanSetting("fullScreen")) {
    fullScreen(P2D, getSettingsManager().getIntegerSetting("monitor"));
  } else {
    size(getSettingsManager().getIntegerSetting("width"), getSettingsManager().getIntegerSetting("height"), P2D);

    // For some reason, you can't set the frameRate if sketch is in fullScreen mode.
    frameRate(getSettingsManager().getIntegerSetting("frameRate"));
  }
}

void setup() {

  // Create Assets class
  assets = new Assets();
  assets.init();

  // Create Audio Manager
  audioManager = new AudioManager(this);

  // Create Screen Manager
  screenManager = new ScreenManager(this);


  loadScreen = new ScreenLoadGame(this);

  screenManager.setScreen(new ScreenMainMenu(this));

}

void draw() {
  screenManager.draw();
  image(screenManager.getScreen(), 0, 0);

  if(gameLoaded) screenManager.setScreen(screenSingingGame);
  gameLoaded = false;
}

// Allow other classes to use main assets
public Assets getAssets() {
  return this.assets;
}

public SettingsManager getSettingsManager() {
  return this.settingsManager;
}

public AudioManager getAudioManager() {
  return this.audioManager;
}

void keyPressed() {
  screenManager.keyPressed();
}

void keyReleased() {
  screenManager.keyReleased();
}
