public abstract class Screen {
  
  PImage canvas;
  Karaoke karaoke;
  
  boolean isRunning;
  
  public Screen(Karaoke karaoke) {
    this.canvas = new PImage(width, height);
    this.karaoke = karaoke;
    this.isRunning = false;
  }
  
  public abstract void start();
  public abstract void draw();
  public abstract void stop();
  
  public PImage getScreen() {
    return this.canvas;
  }
  
}