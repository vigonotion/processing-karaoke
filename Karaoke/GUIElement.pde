public abstract class GUIElement {

  Karaoke karaoke;
  PGraphics canvas;
  int canvasWidth, canvasHeight;

  public GUIElement(Karaoke karaoke, int canvasWidth, int canvasHeight) {
    this.karaoke = karaoke;
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
  }

  public void start() {
    this.canvas = createGraphics(this.canvasWidth, this.canvasHeight, P2D);
  }

  protected abstract void render();

  public void draw(PGraphics container, int x, int y) {
    this.render();
    container.image(this.canvas, x, y);
  }

  public void draw(PGraphics container, int x, int y, int mWidth, int mHeight) {
    this.render();
    container.image(this.canvas, x, y, mWidth, mHeight);
  }

  protected PGraphics createLayer() {
    return createGraphics(this.canvasWidth, this.canvasHeight, P2D);
  }

  public int getCanvasWidth() {
    return this.canvasWidth;
  }

  public int getCanvasHeight() {
    return this.canvasHeight;
  }


}
