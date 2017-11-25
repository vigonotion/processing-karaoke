import processing.video.*;

Movie movie;
KaraokeFile kFile;
Dot dot;

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
  
  
  frameRate(24);
  
  kFile = new KaraokeFile("C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\rolling_in_the_deep.txt");
  
  dot = new Dot();
  
  movie.play();
  kFile.play();
  dot.play();
  
}

String firstLine = "";
String secondLine = "";
void draw() {
  if(movie.available()) {
    movie.read();
  }
    
  tint(50);
  image(movie, 0, 0, width, height);
  
  
  textFont(font_QuickSand_Bold);
  textSize(42);
  text(kFile.getTitle(), 50, 90);
  
  textFont(font_QuickSand);
  textSize(30);
  text(kFile.getArtist(), 50, 130);
  
  
  kFile.update();
  
  firstLine = "";
  secondLine = "";
  if(kFile.getLatestNoteRow() != null) firstLine = (kFile.getLatestNoteRow().getLine());
  if(kFile.getNextNoteRow() != null) secondLine = (kFile.getNextNoteRow().getLine());
  
  textFont(font_OpenSans);
  
  textSize(54);
  text(firstLine, width/2 - textWidth(firstLine)/2, height - 150);
  
  dot.update();
  
  if(firstLine != "" && kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement()) != null)
    dot.setDestination((int)( width/2 - textWidth(firstLine)/2 + textWidth(kFile.getLatestNoteRow().getLastSyllables(kFile.getLatestNoteElement())) + textWidth(kFile.getLatestSyllable())/2) );
  else
    dot.setDestination(0);
    
  textSize(36);
  text(secondLine, width/2 - textWidth(secondLine)/2, height - 80);
  
  
  ellipse(dot.getX(), height-220 - dot.getY(), 10, 10);
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