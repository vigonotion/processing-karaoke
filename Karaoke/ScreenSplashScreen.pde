class ScreenSplashScreen extends Screen {

  private Assets assets;

  private int splashSize;

  long startTime;

  public ScreenSplashScreen(Karaoke karaoke) {
    super(karaoke);

    this.assets = this.karaoke.getAssets();
    this.splashSize = 800;
  }

  @Override
  public void start() {
    this.isRunning = true;
    this.startTime = millis();
  }

  @Override
  public void draw() {
    if(!isRunning) return;

    this.canvas.beginDraw();
    this.canvas.clear();

      // Draw a Splash Image
      this.canvas.background(0);
      this.canvas.image(assets.image_Splash, width/2 - this.splashSize/2, height/2 - this.splashSize/2, this.splashSize, this.splashSize);

    this.canvas.endDraw();
  }

  @Override
  public void stop() {

  }

}
