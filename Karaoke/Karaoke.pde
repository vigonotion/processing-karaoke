private Assets assets;

private ScreenManager screenManager;

private ScreenSingingGame screenSingingGame;
private ScreenSplashScreen screenSplash;

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
  
  // Create a screen
  screenManager.setScreen(new ScreenSplashScreen(this));
}

void draw() {
  screenManager.draw();
  image(screenManager.getScreen(), 0, 0);
}

// Allow other classes to use main assets
public Assets getAssets() {
  return this.assets;
}