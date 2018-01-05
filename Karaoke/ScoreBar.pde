public class ScoreBar extends GUIElement {

  private static final int SCOREBAR_WIDTH = 600;
  private static final int SCOREBAR_HEIGHT = 30;

  private Assets assets;

  Player player1, player2;
  private int score1, score2;

  public ScoreBar(Karaoke karaoke, Player player1, Player player2) {
    super(karaoke, SCOREBAR_WIDTH, SCOREBAR_HEIGHT+100);

    this.assets = this.karaoke.getAssets();

    this.player1 = player1;
    this.player2 = player2;
  }

  @Override
  protected void render() {

    // Draw the Canvas
    this.canvas.beginDraw();
    this.canvas.clear();

      this.score1 = this.player1.getScore();
      this.score2 = this.player2.getScore();

      this.canvas.strokeWeight(0);

      this.canvas.fill(player2.getNoteColor());
      this.canvas.rect(SCOREBAR_HEIGHT, 0, SCOREBAR_WIDTH - SCOREBAR_HEIGHT, SCOREBAR_HEIGHT, 0, SCOREBAR_HEIGHT, SCOREBAR_HEIGHT, 0);

      this.canvas.fill(player1.getNoteColor());
      this.canvas.rect(0, 0, constrain((int)((float)SCOREBAR_WIDTH * ((float)score1 / (float)(score1 + score2))), SCOREBAR_HEIGHT, SCOREBAR_WIDTH-SCOREBAR_HEIGHT), SCOREBAR_HEIGHT, SCOREBAR_HEIGHT, 0, 0, SCOREBAR_HEIGHT);

      this.canvas.textFont(assets.font_QuickSand);
      this.canvas.textSize(30);
      this.canvas.strokeWeight(0);

      this.canvas.fill(255);
      this.canvas.textAlign(LEFT);
      this.canvas.text(score1 - 1, 0, 70);
      this.canvas.textAlign(RIGHT);
      this.canvas.text(score2 - 1, SCOREBAR_WIDTH, 70);

    this.canvas.endDraw();

  }


}
