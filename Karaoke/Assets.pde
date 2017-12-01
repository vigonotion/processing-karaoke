public class Assets {

  public PFont font_OpenSans;
  public PFont font_QuickSand;
  public PFont font_QuickSand_Bold;
  
  public Assets() {
    
  }
  
  public void init() {
    /* Load Fonts */
    font_OpenSans = createFont("assets/OpenSans-Regular.ttf", 32);
  
    font_QuickSand = createFont("assets/Quicksand-Regular.ttf", 32);
    font_QuickSand_Bold = createFont("assets/Quicksand-Bold.ttf", 32);
    
  }

}