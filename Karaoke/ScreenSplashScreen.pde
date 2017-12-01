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
    
    canvas.beginDraw();
    canvas.clear();
    
    canvas.background(0);
    canvas.image(assets.image_Splash, width/2 - this.splashSize/2, height/2 - this.splashSize/2, this.splashSize, this.splashSize);
    
    canvas.endDraw();
  }
  
  @Override
  public void stop() {
    
  }
  
}