import java.util.Map;

public class SettingsManager {

  String file;
  String[] lines;

  HashMap<String, String> settings;

  public SettingsManager(String file) {
    this.file = file;
    this.lines = loadStrings(this.file);

    this.settings = new HashMap<String, String>();

    // Load Settings to HashMap
    for (int i = 0 ; i < lines.length; i++) {
      if(lines[i] == null ||
        lines[i] == "" ||
        lines[i].length() == 0 ||
        lines[i].charAt(0) == ';') continue;


      String[] pair = split(lines[i], '=');
      settings.put(pair[0], pair[1]);
    }

  }

  public String getSetting(String key) {
    return settings.get(key);
  }

  public String set(String key, String value) {
    return settings.put(key, value);
  }

  public int getIntegerSetting(String key) {
    return Integer.parseInt(getSetting(key));
  }

  public double getDoubleSetting(String key) {
    return Double.parseDouble(getSetting(key));
  }

  public boolean getBooleanSetting(String key) {
    return (settings.get(key).equalsIgnoreCase("True") || settings.get(key).equals("1"));
  }

}
