public class SungNoteElement {

  private NoteElement noteElement;
  private float offset;
  private double currentBeatDouble;

  public SungNoteElement(NoteElement noteElement, float offset, double currentBeatDouble) {
    this.noteElement = noteElement;
    this.offset = offset;
    this.currentBeatDouble = currentBeatDouble;
  }

	/**
	* Returns value of noteElement
	* @return
	*/
	public NoteElement getNoteElement() {
		return this.noteElement;
	}

	/**
	* Returns value of offset
	* @return
	*/
	public float getOffset() {
		return this.offset;
	}

	/**
	* Returns value of currentBeatDouble
	* @return
	*/
	public double getCurrentBeatDouble() {
		return this.currentBeatDouble;
	}

	/**
	* Sets new value of noteElement
	* @param
	*/
	public void setNoteElement(NoteElement noteElement) {
		this.noteElement = noteElement;
	}

	/**
	* Sets new value of offset
	* @param
	*/
	public void setOffset(float offset) {
		this.offset = offset;
	}

	/**
	* Sets new value of currentBeatDouble
	* @param
	*/
	public void setCurrentBeatDouble(double currentBeatDouble) {
		this.currentBeatDouble = currentBeatDouble;
	}
}
