class ScreenResults extends Screen {

  private final int BAR_WIDTH = 200;
  private final int BAR_MAX   = 300;
  private final int BAR_GAP   = 80;

  private Assets assets;
  private Player player1, player2;
  private double score1, score2, scoreText1, scoreText2;

  private float height1, height2;

  private boolean isMultiplayer;

  private int wonPlayer;

  public ScreenResults(Karaoke karaoke, Player player1, Player player2, boolean isMultiplayer) {
    super(karaoke);

    this.player1 = player1;
    this.player2 = player2;

    this.score1 = this.player1.getScore();
    this.score2 = this.player2.getScore();

    if(this.score1 > this.score2) {
      this.score2 = map((float)this.score2, 0, (float)this.score1, 0, 1);
      this.score1 = 1f;
      this.wonPlayer = 1;
    } else {
      this.score1 = map((float)this.score1, 0, (float)this.score2, 0, 1);
      this.score2 = 1f;
      this.wonPlayer = 2;
    }

    this.isMultiplayer = isMultiplayer;

    this.assets = this.karaoke.getAssets();

  }

  @Override
  public void start() {
    this.isRunning = true;
  }

  @Override
  public void draw() {
    if(!isRunning) return;

    // Calculate current height
    height1 = lerp(height1, (float)score1, 0.05f);
    height2 = lerp(height2, (float)score2, 0.05f);

    scoreText1 = lerp((float)scoreText1, (float)this.player1.getScore(), 0.05f);
    scoreText2 = lerp((float)scoreText2, (float)this.player2.getScore(), 0.05f);

    this.canvas.beginDraw();
    this.canvas.clear();
    this.canvas.background(0);

      this.canvas.textAlign(LEFT);

      // Draw the title
      this.canvas.fill(255);
      this.canvas.textFont(assets.font_QuickSand_Bold);
      this.canvas.textSize(42);
      this.canvas.text("Auswertung", 50, 90);

      // Draw the subtitle
      this.canvas.textFont(assets.font_QuickSand);
      this.canvas.textSize(30);
      // @TODO: randomize
      this.canvas.text("War das eine Runde!", 50, 130);

      if(this.isMultiplayer) {

        this.canvas.strokeWeight(0);

        this.canvas.fill(player1.getNoteColor());
        this.canvas.rect(50,height,BAR_WIDTH,(float)( -(height - BAR_MAX)* this.height1));

        this.canvas.textFont(assets.font_OpenSans);
        this.canvas.textSize(24);
        this.canvas.fill(255);
        this.canvas.text((int)(scoreText1), 50, (float) (height - this.height1 * (height - BAR_MAX)) - 20);

        this.canvas.fill(player2.getNoteColor());
        this.canvas.rect(50 + BAR_WIDTH + BAR_GAP,height,BAR_WIDTH,(float) (- (height - BAR_MAX) * this.height2));

        this.canvas.textFont(assets.font_OpenSans);
        this.canvas.textSize(24);
        this.canvas.fill(255);
        this.canvas.text((int)(scoreText2), 50 + BAR_WIDTH + BAR_GAP, (float) (height - this.height2 * (height - BAR_MAX)) - 20);


        this.canvas.textFont(assets.font_OpenSans);
        this.canvas.textSize(42);
        this.canvas.textAlign(CENTER);
        this.canvas.fill(255);
        this.canvas.text("Herzlichen Glückwunsch,", 2* width/3, 300);

        this.canvas.textFont(assets.font_OpenSans_Bold);
        this.canvas.text("Spieler " + wonPlayer + "!", 2* width/3, 350);

        this.canvas.textFont(assets.font_OpenSans);
        this.canvas.textSize(24);
        this.canvas.text("Drücke [ENTER] um zum Hauptmenü zurückzukehren.", 2* width/3, height - 350);
      }

    this.canvas.endDraw();
  }

  @Override
  public void stop() {
    this.isRunning = false;
  }


    @Override
    public void keyPressed() {

      // Exit to Main Menu
      if (keyCode == 27 || keyCode == TAB || keyCode == ENTER) {
        key = 0;
        this.karaoke.mainMenu.start();
        this.karaoke.screenManager.setScreen(this.karaoke.mainMenu);
        this.stop();
      }

    }

}
