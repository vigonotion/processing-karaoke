class NoteElement {
  
  private static final int NOTE_TYPE_REGULAR = 0;
  private static final int NOTE_TYPE_GOLDEN = 1;
  private static final int NOTE_TYPE_FREESTYLE = 2;
  private static final int NOTE_TYPE_LINEBREAK = 3;
  
  private int noteType;
  private int position;
  private int duration;
  private int pitch;
  private String syllable;
  
  public NoteElement(int noteType, int position, int duration, int pitch, String syllable) {
    this.noteType = noteType;
    this.position = position;
    this.duration = duration;
    this.pitch = pitch;
    this.syllable = syllable;
  }
  
  public String getSyllable() {
    return this.syllable;
  }
  
  public int getNoteType() {
    return this.noteType;
  }
  
  public int getPosition() {
    return this.position;
  }
  
  @Override
  public String toString() {
    return noteType + " " + position + " " + duration + " " + pitch + " " + syllable;
  }
  
}