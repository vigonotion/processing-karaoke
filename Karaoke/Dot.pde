class Dot {

  int x;
  int y;
  int destination;
  int lastX;
  private boolean finished = true;
  private long startTime = 0;


  // The time [ms] the dot needs to go from the previous point to the new point
  private static final long TIME = 100;

  // How much the dot will go up and down
  private static final int  AMP  = 20;

  public Dot() {

    // Start the dot offscreen
    this.x = -100;

    this.destination = 0;

  }

  public void play() {

  }

  public void update() {

    if(finished) {
      // If the dot is at its destination, set its x coordinate to the desired destination
      this.x = this.destination;

      // Prevent the point from going down (sinus artifact)
      this.y = 0;
    }

    else {

      // Calculate the x position based on the time
      int difference = (destination-lastX);
      float add = constrain(((float)(millis() - startTime) / (float)TIME), 0.0, 1.0);
      this.x = (int)( lastX + difference*add );

      // Calculate the y position with a time-dependend sine function
      if(add >= 1 || difference < 0) finished = true;
      float sinParam = (float)(add) * (float)(PI);
      this.y = (int)(AMP * sin(sinParam));

    }


  }

  // Sets a new Dot position instantly
  public void setX(int x) {
    this.x = x;
  }

  // Sets the destination the dot should go to (animated)
  public void setDestination(int destination) {

    if(destination != this.destination) {
      finished = (this.x == -100);
      startTime = millis();
      lastX = this.x;
    }

    this.destination = destination;
  }

  public int getX() {
    return this.x;
  }

  public int getY() {
    return this.y;
  }
}
