class Dot {
  int x;
  int y;
  int destination;
  int lastX;
  private boolean finished = true;
  private long startTime = 0;
  
  
  // Settings
  private final long TIME = 200;
  private final int  AMP  = 30;
  
  public Dot() {
    this.x = 0;
    this.destination = 0;
    
  }
  
  public void play() {
    
  }
  
  public void update() {
    
    if(finished) {
      this.x = this.destination;
      this.y = 0;
    }
    
    else {
      
      int difference = (destination-lastX);
      float add = constrain(((float)(millis() - startTime) / (float)TIME), 0.0, 1.0);
      this.x = (int)( lastX + difference*add );   
      
      if(add >= 1) finished = true;
      float sinParam = (float)(add) * (float)(PI);
      this.y = (int)(AMP * sin(sinParam));
    }
    
    
  }
  
  public void setX(int x) {
    this.x = x;
  }
  
  public void setDestination(int destination) {
    
    if(destination != this.destination) {
      finished = false;
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