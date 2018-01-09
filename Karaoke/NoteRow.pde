class NoteRow {

  public ArrayList<NoteElement> noteElements;

  String line;
  int firstBeat;
  int endBeat;

  public NoteRow(ArrayList<NoteElement> noteElements, int endBeat) {
    this.noteElements = noteElements;

    // Set the endBeat, and if it isn't defined (0) it will be calculated
    // --> The last beat is equal to the position of the last note element in the row plus its duration
    if(endBeat > 0)
      this.endBeat = endBeat;
    else this.endBeat = noteElements.get(noteElements.size()-1).getPosition() + noteElements.get(noteElements.size()-1).getDuration();

    this.line = "";

    // The first beat is the position of the first note in the list
    this.firstBeat = noteElements.get(0).getPosition();

    // Concatenate the current line by adding all syllables of this row
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

  public int getEndBeat() {
    return this.endBeat;
  }

  public int getDuration() {
    return this.endBeat - this.firstBeat;
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

  public ArrayList<NoteElement> getNoteElements() {
    return this.noteElements;
  }
}
