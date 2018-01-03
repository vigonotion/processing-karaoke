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

    canvas.beginDraw();
    canvas.clear();
    canvas.background(0);

    canvas.noFill();
    canvas.strokeWeight(10);
    canvas.stroke(255);
    canvas.ellipseMode(CORNER);
    canvas.arc(width/2-100, height/2-100, 200, 200, 0 + millis()*0.004f, HALF_PI + millis()*0.004f);

    canvas.textAlign(CENTER);
    canvas.textFont(assets.font_OpenSans);
    canvas.textSize(30);
    canvas.text("Lädt...", width/2, height/2 + 200);

    canvas.endDraw();
  }

  @Override
  public void stop() {
    this.isRunning = false;
  }

}
