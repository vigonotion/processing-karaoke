public abstract class GUIElement {

  protected Karaoke karaoke;
  protected PGraphics canvas;
  protected int canvasWidth, canvasHeight;

  public GUIElement(Karaoke karaoke, int canvasWidth, int canvasHeight) {
    this.karaoke = karaoke;
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;

    // Creates the canvas (PGraphics) to be drawn on
    this.canvas = createGraphics(this.canvasWidth, this.canvasHeight, P2D);
  }

  // This should be overridden with the render code of a subclass
  protected abstract void render();

  // Draws the PGraphics onto another PGraphics
  public void draw(PGraphics container, int x, int y) {
    this.render();
    container.image(this.canvas, x, y);
  }

  // Draws the PGraphics onto another PGraphics (with width and height)
  public void draw(PGraphics container, int x, int y, int mWidth, int mHeight) {
    this.render();
    container.image(this.canvas, x, y, mWidth, mHeight);
  }

  public int getCanvasWidth() {
    return this.canvasWidth;
  }

  public int getCanvasHeight() {
    return this.canvasHeight;
  }


}
