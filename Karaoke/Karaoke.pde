private Assets assets;

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
  
  // Create the Game Screen
  //screenSingingGame = new ScreenSingingGame(this);
  //screenSingingGame.start();
  screenSplash = new ScreenSplashScreen(this);
  screenSplash.start();
}


void draw() {
  //screenSingingGame.draw();
  //image(screenSingingGame.getScreen(), 0, 0);
  screenSplash.draw();
  image(screenSplash.getScreen(), 0, 0);
}

// Allow other classes to use main assets
public Assets getAssets() {
  return this.assets;
}