class NoteRow {
  
  public ArrayList<NoteElement> noteElements;
  
  String line;
  int firstBeat;
  int endBeat;
  
  public NoteRow(ArrayList<NoteElement> noteElements, int endBeat) {
    this.noteElements = noteElements;
    
    if(endBeat > 0)
      this.endBeat = endBeat;
    else this.endBeat = noteElements.get(noteElements.size()-1).getPosition() + noteElements.get(noteElements.size()-1).getDuration();
    
    this.line = "";
    this.firstBeat = noteElements.get(0).getPosition();
    
    for(NoteElement el : noteElements) {
      this.line += el.getSyllable();
      if(el.getPosition() < this.firstBeat) this.firstBeat = el.getPosition();
    }
  }
  
  @Override
  public String toString() {
    return this.line;
  }
  
  public int getFirstBeat() {
    return this.firstBeat;
  }
  
  public int getSyllablePosition(NoteElement e) {
    return this.noteElements.indexOf(e);
  }
  
  public String getLastSyllables(NoteElement e) {
    
    // When line is finished, return -1
    if(getSyllablePosition(e) < 0) return "-1";
    
    if(!noteElements.contains(e)) return null;
    
    String lasts = "";
    ArrayList<NoteElement> lastNoteElements = new ArrayList<NoteElement>(noteElements.subList(0, getSyllablePosition(e)));
    
    for(NoteElement el : lastNoteElements) {
      lasts += el.getSyllable();
    }
    
    return lasts;
  }
}