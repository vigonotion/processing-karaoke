public class ScreenManager extends Screen {

  Screen currentScreen;
  Screen nextScreen;

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

    // Draw the current screen

    if(this.currentScreen != null && this.currentScreen.isRunning) {
      this.canvas.beginDraw();
      this.canvas.clear();

        this.currentScreen.draw();
        this.canvas.image(this.currentScreen.getScreen(), 0, 0);
        
      this.canvas.endDraw();
    }

  }

  public void keyPressed() {
    if(this.currentScreen != null && this.currentScreen.isRunning)
    this.currentScreen.keyPressed();
  }

  public void keyReleased() {
    if(this.currentScreen != null && this.currentScreen.isRunning)
    this.currentScreen.keyReleased();
  }

  public void mousePressed() {
    if(this.currentScreen != null && this.currentScreen.isRunning)
    this.currentScreen.mousePressed();
  }

  public void mouseReleased() {
    if(this.currentScreen != null && this.currentScreen.isRunning)
    this.currentScreen.mouseReleased();
  }

  @Override
  public void stop() {

  }

}
