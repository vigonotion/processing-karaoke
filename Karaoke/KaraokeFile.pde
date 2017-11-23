class KaraokeFile {
    
  private ArrayList<NoteElement> noteElements;
  
  int bpm;
  int gap;
  
  long startTime;
  int currentBeat;
  
  ArrayList<NoteRow> noteRows;
    
  public KaraokeFile(String file) {
    
    String[] lines = loadStrings(file);
    noteElements = new ArrayList<NoteElement>();
    noteRows = new ArrayList<NoteRow>();
    
    println("there are " + lines.length + " lines");
    for (int i = 0 ; i < lines.length; i++) {
      if(lines[i] == null) continue;
      
      if(lines[i].charAt(0) == '#') {
        
        println("Setting: " + lines[i]);
        
        String[] kv = split(lines[i], ':');
        String key = kv[0];
        String value = kv[1];
        
        if(key.equals("#BPM")) bpm = Integer.valueOf(value);
        if(key.equals("#GAP")) gap = Integer.valueOf(value);
      
      } else {
        String[] elements = splitCommands(lines[i]);
        
        int noteType = NoteElement.NOTE_TYPE_REGULAR;
        
        switch(elements[0].charAt(0)) {
          case ':':
            noteType = NoteElement.NOTE_TYPE_REGULAR;
            break;
          case '*':
            noteType = NoteElement.NOTE_TYPE_GOLDEN;
            break;
          case 'F':
            noteType = NoteElement.NOTE_TYPE_FREESTYLE;
            break;
          case '-':
            noteType = NoteElement.NOTE_TYPE_LINEBREAK;
            break;
          
        }
        
          NoteElement noteElement = new NoteElement(noteType, Integer.valueOf(elements[1]), Integer.valueOf(elements[2]), Integer.valueOf(elements[3]), elements[4]);
          noteElements.add(noteElement);
          //print(elements[1] + "|" + elements[2] + "|" + elements[3] + "|" + elements[4] + "\n");
        
      }
    }
    
    ArrayList<NoteElement> noteRowElements = new ArrayList<NoteElement>();
    
    for(NoteElement i : noteElements) {
      
      if(i.getNoteType() == NoteElement.NOTE_TYPE_LINEBREAK) {
        //println();

        noteRows.add(new NoteRow((ArrayList<NoteElement>)noteRowElements.clone()));
        noteRowElements = new ArrayList<NoteElement>();
        
      } else {
        //print(i.getSyllable());
        //println((new NoteRow((ArrayList<NoteElement>)noteRowElements.clone())).getLine());
        noteRowElements.add(i);
        
      }
      
    }
    
    for(NoteRow r : noteRows) {
      //println(r.getLine());
    }

  }
  
  
  public String[] splitCommands(String command) {
    char cmd[] = command.toCharArray();
    String r[] = {"", "", "", "", ""};
    int spaceCount = 0;
    
    for(int i=0; i<cmd.length; i++) {
      if(spaceCount < 4) {
        
        if(cmd[i] == ' ') spaceCount++;
        else r[spaceCount] += cmd[i];        
        
      } else {
        r[4] += cmd[i];
      }
    }
    
    // override defaults:
     if(r[0].equals("")) r[0] = ":";
     if(r[1].equals("")) r[1] = "0";
     if(r[2].equals("")) r[2] = "0";
     if(r[3].equals("")) r[3] = "0";
    
    return r;
    
  }
  
  public void play() {
    startTime = millis();
    //currentBeat = -gap;
  }
  
  int lastRow = 0;
  
  public void update() {
    //currentBeat = (int) (this.bpm*60) * (int)(millis() - startTime) / 1000 - gap*60;
    long elapsed = (millis() - startTime) - gap;
    
    // You have to multiply the beats by 4 because they use quarter beats
    currentBeat = (int) (((double) ((double)bpm * 4 / 60000) * (double) elapsed));
    
    //println(currentBeat + "|" + elapsed + " --> " + getLatestSyllable());
    
    if(getLatestNoteRow() != null) println(getLatestNoteRow().getLine());
    
  }
  
  public NoteRow getLatestNoteRow() {
    
    int biggest = -200;
    NoteRow biggestRow = null;
    
    for(NoteRow r : noteRows) {
      if(r.getFirstBeat() < currentBeat && r.getFirstBeat() >= biggest) {
        biggest = r.getFirstBeat();
        biggestRow = r;
      }
    }
    
    return biggestRow;
    
  }
  
  public NoteRow getNextNoteRow() {
    NoteRow current = getLatestNoteRow();
    
    if(current != null) {
      int index = noteRows.indexOf(current);
      if(noteRows.get(index+1) != null) return noteRows.get(index+1);
    } else if(current == null && (millis() - startTime) < 20000) {
      if(noteRows.get(0) != null) return noteRows.get(0);
    }
    return null;
  }
  
  private NoteElement getLatestNoteElement() {
    
    int biggest = -200;
    NoteElement biggestEl = null;
    
    for(NoteElement n : noteElements) {
      int pos = n.getPosition();
      if(pos < currentBeat && pos >= biggest)  {
        biggestEl = n;
        biggest = pos;
      }
    }
    
    if(biggestEl != null) return biggestEl;
    return null;
    
  }
  
  private String getLatestSyllable() {
    
    int biggest = -200;
    NoteElement biggestEl = null;
    
    for(NoteElement n : noteElements) {
      int pos = n.getPosition();
      if(pos < currentBeat && pos >= biggest)  {
        biggestEl = n;
        biggest = pos;
      }
    }
    
    if(biggestEl != null) return biggestEl.getSyllable();
    return "";
    
  }
  
}