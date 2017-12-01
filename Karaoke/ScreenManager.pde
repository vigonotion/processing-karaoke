public class ScreenManager extends Screen {
    
  Screen currentScreen;
  Screen nextScreen;
  
  // @TODO: Add Animator
  
  public ScreenManager(Karaoke karaoke) {
    super(karaoke);
  }
  
  public void setScreen(Screen screen) {
    this.currentScreen = screen;
    this.currentScreen.start();
  }
  
  @Override
  public void start() {
    
  }
  
  @Override
  public void draw() {
    
    if(currentScreen != null && currentScreen.isRunning) {
      canvas.beginDraw();
      canvas.clear();
      currentScreen.draw();
      canvas.image(currentScreen.getScreen(), 0, 0);
      canvas.endDraw();
    }
    
  }
  
  @Override
  public void stop() {
    
  }
  
}