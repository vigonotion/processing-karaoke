import processing.video.*;

public class ScreenSingingGame extends Screen {
  
  private Assets assets;
  
  private Movie movie;
  private KaraokeFile kFile;
  
  private String firstLine = "";
  private String secondLine = "";
  
  public ScreenSingingGame(Karaoke karaoke) {
    super(karaoke);
    
    this.assets = this.karaoke.getAssets();
    
    this.movie = new Movie(this.karaoke, "C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\rolling_in_the_deep.mp4");
    this.movie.frameRate(24);
    
    this.kFile = new KaraokeFile("C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\rolling_in_the_deep.txt");
  }
  
  @Override
  public void start() {
    this.isRunning = true;
    movie.play();
    kFile.play(movie);
    kFile.dot.play();
  }
  
  @Override
  public void draw() {
    
    if(!isRunning) return;
    
    if(movie.available()) {
      movie.read();
      
    }
      
    tint(50);
    image(movie, 0, 0, width, height);
    
    fill(255);
    textFont(assets.font_QuickSand_Bold);
    textSize(42);
    text(kFile.getTitle(), 50, 90);
    
    textFont(assets.font_QuickSand);
    textSize(30);
    text(kFile.getArtist(), 50, 130);
    
    
    kFile.update();
    
    firstLine = "";
    secondLine = "";
    if(kFile.getLatestNoteRow() != null) firstLine = (kFile.getLatestNoteRow().toString());
    if(kFile.getNextNoteRow() != null) secondLine = (kFile.getNextNoteRow().toString());
    
    textFont(assets.font_OpenSans);
    
    textSize(54);
    text(firstLine, width/2 - textWidth(firstLine)/2, height - 150);
    
    if(!firstLine.equals("")
    && kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement()) != null)
    {
      int dest = -100;
      
      dest = (int)( width/2 - textWidth(firstLine)/2
      + textWidth(kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement(true)))
      + textWidth(kFile.getLatestSyllable(true))/2);
      
      if(!kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement(true)).equals("-1"))
      kFile.dot.setDestination(dest);
    } else {
      kFile.dot.setX(-100);
    }
      
    textSize(36);
    text(secondLine, width/2 - textWidth(secondLine)/2, height - 80);
    
    
    ellipse(kFile.dot.getX(), height-220 - kFile.dot.getY(), 10, 10);
    
    int bubblePos = (int)( -kFile.currentBeatDouble * kFile.bpm/8);
    
    /*
    strokeWeight(1);
    stroke(0);
    line(width/2, 0, width/2, height);
    */
    
    strokeWeight(0);
    
    for(NoteElement e : kFile.getNoteElements()) {
      fill(220);
      
      if(e.noteType == NoteElement.NOTE_TYPE_GOLDEN)
        fill(224,184,134);
      
      if(kFile.sung(e))
        fill(43,221,160);
      
      rect(width/2 + bubblePos + e.position * kFile.bpm/8, height/2 - e.pitch * 15, e.duration * kFile.bpm/8, 15, 15);
      
      if(!kFile.sung(e) && kFile.singing(e)) {
        fill(43,221,160);
        rect(width/2, height/2 - e.pitch * 15, - (float)(kFile.currentBeatDouble - e.position)* kFile.bpm/8, 15, 15);
      }
  
    }
    
    if(kFile.getLatestNoteRow() != null) 
    for(NoteElement e : kFile.getLatestNoteRow().noteElements) {
      //println(e);
    }
  }
  
  @Override
  public void stop() {
    
  }
  
}