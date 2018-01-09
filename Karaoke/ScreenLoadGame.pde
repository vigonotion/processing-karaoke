class ScreenLoadGame extends Screen {

  private Assets assets;

  public ScreenLoadGame(Karaoke karaoke) {
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

    this.canvas.beginDraw();
    this.canvas.clear();

      this.canvas.background(0);

      this.canvas.noFill();
      this.canvas.strokeWeight(10);
      this.canvas.stroke(255);
      this.canvas.ellipseMode(CORNER);

      // Draw half of a circle and rotate it based on time
      this.canvas.arc(width/2-100, height/2-100, 200, 200, 0 + millis()*0.004f, HALF_PI + millis()*0.004f);

      this.canvas.textAlign(CENTER);
      this.canvas.textFont(assets.font_OpenSans);
      this.canvas.textSize(30);

      // Draw a String
      this.canvas.text("Lädt...", width/2, height/2 + 200);

    this.canvas.endDraw();
  }

  @Override
  public void stop() {
    this.isRunning = false;
  }

}
