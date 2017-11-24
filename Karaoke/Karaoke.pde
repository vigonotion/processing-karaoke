import processing.video.*;

Movie movie;
KaraokeFile kFile;

PFont font_OpenSans;

void setup() {
  //fullScreen(P2D);
  size(1920, 1080, P2D);
  //selectInput("Select a file to process:", "fileSelected");
  
  font_OpenSans = createFont("assets/OpenSans-Regular.ttf", 32);
  
  movie = new Movie(this, "C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\rolling_in_the_deep.mp4");
  movie.frameRate(24);
  
  
  frameRate(24);
  
  kFile = new KaraokeFile("C:\\Users\\tom\\SynologyDrive\\Studium\\Informatik 1 Projekt\\Karaoke\\processing-karaoke\\files\\rolling_in_the_deep.txt");
  
  movie.play();
  kFile.play();
  
}

String firstLine = "";
String secondLine = "";
void draw() {
  if(movie.available()) {
    movie.read();
  }
  
  float ratio = 16/9;
  
  tint(50);
  image(movie, 0, 0, width, height);
  kFile.update();
  
  firstLine = "";
  secondLine = "";
  if(kFile.getLatestNoteRow() != null) firstLine = (kFile.getLatestNoteRow().getLine());
  if(kFile.getNextNoteRow() != null) secondLine = (kFile.getNextNoteRow().getLine());
  
  textFont(font_OpenSans);
  
  textSize(54);
  text(firstLine, width/2 - textWidth(firstLine)/2, height - 150);
  
  textSize(36);
  text(secondLine, width/2 - textWidth(secondLine)/2, height - 80);
  
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