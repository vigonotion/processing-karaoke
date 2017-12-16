private Assets assets;

private ScreenManager screenManager;
private ScreenSingingGame screenSingingGame;

boolean gameLoaded = false;

void setup() {

  // Window Settings, P2D as Renderer (faster)
  //fullScreen(P2D);
  size(1920, 1080, P2D);
  frameRate(30);

  // Create Assets class
  assets = new Assets();
  assets.init();

  // Create Screen Manager
  screenManager = new ScreenManager(this);

  screenManager.setScreen(new ScreenMainMenu(this));

  /* @TODO: add this to main menu loader
  // Create a screen
  screenManager.setScreen(new ScreenSplashScreen(this));

  // Load Game in separate thread
  thread("loadGameThread");
  */
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

public void loadGameThread(KaraokeFile kFile) {
  screenSingingGame = new ScreenSingingGame(this, kFile);
  screenSingingGame.start();
  this.gameLoaded = true;
}

void keyPressed() {
  screenManager.keyPressed();
}

void keyReleased() {
  screenManager.keyReleased();
}
