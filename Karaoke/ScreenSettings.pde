class ScreenSettings extends Screen {

  private final int SLIDER_WIDTH = 300;
  private final int SLIDER_HEIGHT = 30;
  private final int KNOB_WIDTH = 10;

  float sliderPosition[];

  private Assets assets;

  private boolean mouseClicked = false;

  PitchDetector detector1, detector2;

  public ScreenSettings(Karaoke karaoke) {
    super(karaoke);
    this.assets = this.karaoke.getAssets();

    this.detector1 = new FFTPitchDetector(this.karaoke, this.karaoke.getAudioManager().getAudioInput(1), 44100, 2048);
    this.detector2 = new FFTPitchDetector(this.karaoke, this.karaoke.getAudioManager().getAudioInput(2), 44100, 2048);

    this.sliderPosition = new float[]{
      constrain(map((float) this.karaoke.getSettingsManager().getDoubleSetting("volume1"), (float) 0, (float) 50, (float) 0, (float) 1),0,1),
      constrain(map((float) this.karaoke.getSettingsManager().getDoubleSetting("volume2"), (float) 0, (float) 50, (float) 0, (float) 1),0,1)
    };
  }

  @Override
  public void start() {
    this.isRunning = true;
  }

  @Override
  public void draw() {
    if(!isRunning) return;

    // Analyze for volume
    this.detector1.analyze();
    this.detector2.analyze();

    this.canvas.beginDraw();
    this.canvas.clear();
    this.canvas.background(0);

    // Draw the title
    this.canvas.fill(255);
    this.canvas.textFont(assets.font_QuickSand_Bold);
    this.canvas.textSize(42);
    this.canvas.text("Einstellungen", 50, 90);

    // Draw the subtitle
    this.canvas.textFont(assets.font_QuickSand);
    this.canvas.textSize(30);
    this.canvas.text("« Zurück zum Hauptmenü", 50, 130);

    // Draw the settings
    this.canvas.textFont(assets.font_OpenSans);
    this.canvas.textSize(30);
    this.canvas.strokeWeight(0);

    drawSlider(1);
    drawSlider(2);

    this.canvas.endDraw();

  }

  private void drawSlider(int index) {

    int hOffset = 50;
    if(index == 2) hOffset = width/2;

    float volume = this.detector1.getVolume();
    if(index == 2) volume = this.detector2.getVolume();

    this.canvas.fill(255);
    this.canvas.textAlign(LEFT);
    this.canvas.text("Mikrofon " + index, hOffset, 350);

    // Slider
    // Inner Box
    if(volume > this.karaoke.getSettingsManager().getDoubleSetting("volume" + index)) this.canvas.fill(67,133,87); // draw green if detected
    else this.canvas.fill(133,67,72); // or red if noise


    this.canvas.strokeWeight(0);

    this.canvas.rect(hOffset, 380, SLIDER_WIDTH * constrain(map(volume, 0, 50, 0, 1),0,1), SLIDER_HEIGHT);

    // Outer Box
    this.canvas.noFill();
    this.canvas.strokeWeight(2);
    this.canvas.stroke(255);

    this.canvas.rect(hOffset, 380, SLIDER_WIDTH, SLIDER_HEIGHT);

    // Knob
    this.canvas.fill(255);
    this.canvas.strokeWeight(0);

    this.canvas.rect(hOffset + SLIDER_WIDTH * sliderPosition[index-1], 380, KNOB_WIDTH, SLIDER_HEIGHT);

    // Update Slider
    if(mouseClicked && ( mouseX >= hOffset + KNOB_WIDTH/2 && mouseX <= hOffset + SLIDER_WIDTH - KNOB_WIDTH/2  && mouseY >= 380 && mouseY <= 380 + SLIDER_HEIGHT )) {

      this.sliderPosition[index-1] = constrain(map(mouseX-KNOB_WIDTH/2, hOffset, hOffset+SLIDER_WIDTH, 0, 1), 0, 1);

      // Update corresponding setting
      this.karaoke.getSettingsManager().set("volume" + index, Float.toString(this.sliderPosition[index-1] * 50));
    }
  }

  @Override
  public void stop() {

  }

  @Override
  public void mousePressed() {

    mouseClicked = true;

  }

  @Override
  public void mouseReleased() {

    mouseClicked = false;

  }

  @Override
  public void keyPressed() {

    // Exit to Main Menu
    if (keyCode == 27 || keyCode == TAB) {
      key = 0;
      this.karaoke.mainMenu.start();
      this.karaoke.screenManager.setScreen(this.karaoke.mainMenu);
    }

    // Navigation
    if(keyCode == RIGHT) {}
    else if(keyCode == LEFT) {}

    // Select
    if(keyCode == ENTER) {}

  }

}
