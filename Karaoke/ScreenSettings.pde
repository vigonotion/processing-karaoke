class ScreenSettings extends Screen {

  private final int SLIDER_WIDTH = 500;
  private final int SLIDER_HEIGHT = 30;
  private final int KNOB_WIDTH = 10;
  private final int CHECKBOX_WIDTH = 30;

  float sliderPosition[];
  int selectedInput[];

  private Assets assets;

  private boolean mouseClicked = false;

  Mixer.Info[] mixerInfo;
  int activeMixer = -1;

  FFTPitchDetector detector1, detector2;

  ArrayList<MicInputItem>[] items;

  public ScreenSettings(Karaoke karaoke) {
    super(karaoke);
    this.assets = this.karaoke.getAssets();

    this.mixerInfo = AudioSystem.getMixerInfo();

    this.detector1 = new FFTPitchDetector(this.karaoke, this.karaoke.getAudioManager().getAudioInput(1), 44100, 2048);
    this.detector2 = new FFTPitchDetector(this.karaoke, this.karaoke.getAudioManager().getAudioInput(2), 44100, 2048);

    this.sliderPosition = new float[]{
      constrain(map((float) this.karaoke.getSettingsManager().getDoubleSetting("volume1"), (float) 0, (float) 50, (float) 0, (float) 1),0,1),
      constrain(map((float) this.karaoke.getSettingsManager().getDoubleSetting("volume2"), (float) 0, (float) 50, (float) 0, (float) 1),0,1)
    };

    this.selectedInput = new int[]{this.karaoke.getSettingsManager().getIntegerSetting("mixer1"), this.karaoke.getSettingsManager().getIntegerSetting("mixer2")};

    this.items = new ArrayList[2];

    this.items[0] = new ArrayList<MicInputItem>();
    this.items[1] = new ArrayList<MicInputItem>();

    this.items[0].add(new MicInputItem(this.karaoke, "Unbelegt", 0));
    this.items[1].add(new MicInputItem(this.karaoke, "Unbelegt", 0));

    for(int i = 0; i < mixerInfo.length; i++) {
      String label = mixerInfo[i].getName();
      String llabel = label.toLowerCase();
      // Filter them
      if(llabel.contains("aufnahme") || llabel.contains("record") || llabel.contains("input") || llabel.contains("mikro") || llabel.contains("micro")) {
        this.items[0].add(new MicInputItem(this.karaoke, label, i));
        this.items[1].add(new MicInputItem(this.karaoke, label, i));
      }
    }
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
    // Multiplayer Checkbox
    this.canvas.strokeWeight(2);
    this.canvas.stroke(255);
    if(this.karaoke.getSettingsManager().getBooleanSetting("multiplayer")) this.canvas.fill(255);
    else this.canvas.noFill();

    this.canvas.rect(50, 250, CHECKBOX_WIDTH, CHECKBOX_WIDTH);

    this.canvas.textFont(assets.font_OpenSans);
    this.canvas.textSize(24);
    this.canvas.strokeWeight(0);

    this.canvas.fill(255);
    this.canvas.textAlign(LEFT);
    this.canvas.text("Mehrspieler", 50 + CHECKBOX_WIDTH + 20, 250 + CHECKBOX_WIDTH - 6);

    if(this.karaoke.getSettingsManager().getBooleanSetting("multiplayer")) {
      this.canvas.noFill();
      this.canvas.strokeWeight(2);
      this.canvas.stroke(0);

      this.canvas.line(50 + 2, 250 + 2, 50 + CHECKBOX_WIDTH - 2, 250 + CHECKBOX_WIDTH - 2);
      this.canvas.line(50 + CHECKBOX_WIDTH - 2, 250 + 2, 50 + 2, 250 + CHECKBOX_WIDTH - 2);
    }



    drawMicSettings(1);
    drawMicSettings(2);

    this.canvas.endDraw();

  }

  private void drawMicSettings(int index) {

    int hOffset = 50;
    if(index == 2) hOffset = width/2;

    float volume = this.detector1.getVolume();
    if(index == 2) volume = this.detector2.getVolume();

    this.canvas.textFont(assets.font_OpenSans_Bold);
    this.canvas.textSize(30);
    this.canvas.strokeWeight(0);

    this.canvas.fill(255);
    this.canvas.textAlign(LEFT);
    this.canvas.text("Mikrofon " + index + " Schwellwert", hOffset, 350);

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

    // Draw the Inputs
    this.canvas.fill(255);
    this.canvas.textAlign(LEFT);
    this.canvas.text("Mikrofon " + index + " Eingang", hOffset, 500);

    int itemSpace = 50;
    int i = 0;
    for(MicInputItem item : items[index-1]) {

        // Checks if this item is selected elsewhere
        if(selectedInput[index%2] == item.getMixer()) {
          item.state = MicInputItem.STATE_UNAVAILABLE;
        }
        // Check if this item is selected...
        else if(selectedInput[index-1] == item.getMixer()) {
          if(  this.karaoke.getAudioManager().getAudioInput(index) == null) item.state = MicInputItem.STATE_ERROR;
          else item.state = MicInputItem.STATE_AVAILABLE;
        } else {
          item.state = MicInputItem.STATE_IDLE;
        }

        item.draw(this.canvas, hOffset, 530 + i*itemSpace);

        // If clicked on any of the input manager items...
        if(mouseClicked && selectedInput[index-1] != item.getMixer() && selectedInput[index%2] != item.getMixer() && ( mouseX >= hOffset && mouseX <= hOffset + item.getCanvasWidth() && mouseY >= 530 + (i*itemSpace) && mouseY <= 530 + (i*itemSpace) + item.getCanvasHeight() )) {
          selectedInput[index-1] = item.getMixer();
          println("Selected Mixer " + item.getMixer());

          this.karaoke.getAudioManager().setMixer(index, item.getMixer());
          if(index == 1) this.detector1.setAudioInput(this.karaoke.getAudioManager().getAudioInput(1));
          if(index == 2) this.detector2.setAudioInput(this.karaoke.getAudioManager().getAudioInput(2));
          println("updated it");
        }

        i++;
    }

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

    if( ( mouseX >= 50 && mouseX <= 50 + CHECKBOX_WIDTH && mouseY >= 250 && mouseY <= 250 + CHECKBOX_WIDTH )) {
      this.karaoke.getSettingsManager().set("multiplayer", Boolean.toString(!this.karaoke.getSettingsManager().getBooleanSetting("multiplayer")));
    }

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
      this.karaoke.getSettingsManager().save();
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
