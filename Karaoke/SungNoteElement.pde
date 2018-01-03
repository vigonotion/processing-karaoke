public class SungNoteElement {

  private NoteElement noteElement;
  private float offset;
  private double position;

  public SungNoteElement(NoteElement noteElement, float offset, double position) {
    this.noteElement = noteElement;
    this.offset = offset;
    this.position = position;
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
	* Returns value of position
	* @return
	*/
	public double getPosition() {
		return this.position;
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
	* Sets new value of position
	* @param
	*/
	public void setPosition(double position) {
		this.position = position;
	}
}
