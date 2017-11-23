class NoteRow {
  
  public ArrayList<NoteElement> noteElements;
  
  String line;
  int firstBeat;
  
  public NoteRow(ArrayList<NoteElement> noteElements) {
    this.noteElements = noteElements;
    
    this.line = "";
    this.firstBeat = noteElements.get(0).getPosition();
    
    for(NoteElement el : noteElements) {
      this.line += el.getSyllable();
      if(el.getPosition() < this.firstBeat) this.firstBeat = el.getPosition();
    }
  }
  
  public String getLine() {
    return this.line;
  }
  
  public int getFirstBeat() {
    return this.firstBeat;
  }
}