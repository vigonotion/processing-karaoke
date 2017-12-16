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

  public void keyPressed() {
    if(currentScreen != null && currentScreen.isRunning)
    currentScreen.keyPressed();
  }

  public void keyReleased() {
    if(currentScreen != null && currentScreen.isRunning)
    currentScreen.keyReleased();
  }

  @Override
  public void stop() {

  }

}
