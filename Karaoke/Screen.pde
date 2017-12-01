public abstract class Screen {
  
  PGraphics canvas;
  Karaoke karaoke;
  
  public boolean isRunning;
  
  public Screen(Karaoke karaoke) {
    this.canvas = createGraphics(width, height, P2D);
    this.karaoke = karaoke;
    this.isRunning = false;
  }
  
  public abstract void start();
  public abstract void draw();
  public abstract void stop();
  
  public PGraphics getScreen() {
    return this.canvas;
  }
  
}