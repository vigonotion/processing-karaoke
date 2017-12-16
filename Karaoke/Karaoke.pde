private Assets assets;

private ScreenManager screenManager;
private ScreenSingingGame screenSingingGame;

private ScreenLoadGame loadScreen;

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

void keyPressed() {
  screenManager.keyPressed();
}

void keyReleased() {
  screenManager.keyReleased();
}
