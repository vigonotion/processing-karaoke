import processing.video.*;

Movie movie;
KaraokeFile kFile;

PFont font_OpenSans;
PFont font_QuickSand;
PFont font_QuickSand_Bold;

void setup() {
  //fullScreen(P2D);
  size(1920, 1080, P2D);
  //selectInput("Select a file to process:", "fileSelected");
  
  font_OpenSans = createFont("assets/OpenSans-Regular.ttf", 32);
  
  font_QuickSand = createFont("assets/Quicksand-Regular.ttf", 32);
  font_QuickSand_Bold = createFont("assets/Quicksand-Bold.ttf", 32);
  
  movie = new Movie(this, "C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\rolling_in_the_deep.mp4");
  movie.frameRate(24);
  
  
  frameRate(30);
  
  kFile = new KaraokeFile("C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\rolling_in_the_deep.txt");
      
  movie.play();
  kFile.play(movie);
  kFile.dot.play();
    
}

String firstLine = "";
String secondLine = "";
void draw() {
  if(movie.available()) {
    movie.read();
    
  }
    
  tint(50);
  image(movie, 0, 0, width, height);
  
  fill(255);
  textFont(font_QuickSand_Bold);
  textSize(42);
  text(kFile.getTitle(), 50, 90);
  
  textFont(font_QuickSand);
  textSize(30);
  text(kFile.getArtist(), 50, 130);
  
  
  kFile.update();
  
  firstLine = "";
  secondLine = "";
  if(kFile.getLatestNoteRow() != null) firstLine = (kFile.getLatestNoteRow().toString());
  if(kFile.getNextNoteRow() != null) secondLine = (kFile.getNextNoteRow().toString());
  
  textFont(font_OpenSans);
  
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

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    //movie = new Movie(this, selection.getAbsolutePath());
    //movie.play();
  }
}