class ScreenMainMenu extends Screen {

  private Assets assets;

  public ScreenSplashScreen(Karaoke karaoke) {
    super(karaoke);

    this.assets = this.karaoke.getAssets();
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

    // add menu draw methods here...

    canvas.endDraw();
  }

  @Override
  public void stop() {

  }

}
