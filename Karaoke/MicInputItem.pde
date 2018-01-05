public class MicInputItem extends GUIElement {

  public static final int STATE_UNAVAILABLE = -2;
  public static final int STATE_ERROR = -1;
  public static final int STATE_IDLE = 0;
  public static final int STATE_AVAILABLE = 1;

  private static final int CONTAINER_WIDTH = 600;
  private static final int CONTAINER_HEIGHT = 40;

  private Assets assets;

  String label;
  int mixer;

  byte state = STATE_IDLE;

  public MicInputItem(Karaoke karaoke, String label, int mixer) {
    super(karaoke, CONTAINER_WIDTH, CONTAINER_HEIGHT);

    this.assets = this.karaoke.getAssets();

    this.label = label;
    this.mixer = mixer;
  }

  @Override
  protected void render() {

    // Draw the Canvas
    this.canvas.beginDraw();
    this.canvas.clear();

      this.canvas.strokeWeight(0);
      this.canvas.fill(25);
      if(this.state == STATE_AVAILABLE) this.canvas.fill( 0, 128, 0 );
      else if(this.state == STATE_ERROR) this.canvas.fill( 255, 0, 0 );
      else if(this.state == STATE_UNAVAILABLE) this.canvas.fill(25);
      this.canvas.rect(0, 0, this.canvasWidth, this.canvasHeight);

      this.canvas.textFont(assets.font_OpenSans);
      this.canvas.textSize(24);
      this.canvas.strokeWeight(0);
      this.canvas.fill(255);
      if(this.state == STATE_UNAVAILABLE) this.canvas.fill(80);
      this.canvas.textAlign(LEFT);
      this.canvas.text(this.label, 8, 28);

    this.canvas.endDraw();

  }

  public int getMixer() {
    return this.mixer;
  }


}
