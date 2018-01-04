import ddf.minim.*;
import javax.sound.sampled.*;

public class AudioManager {

  Karaoke karaoke;

  Minim minim1, minim2;
  AudioInput in1, in2;
  Mixer.Info[] mixerInfo;

  public AudioManager(Karaoke karaoke) {
    this.karaoke = karaoke;

    // Initialize everything
    this.minim1 = new Minim(this.karaoke);
    this.minim2 = new Minim(this.karaoke);
    this.mixerInfo = AudioSystem.getMixerInfo();

    // Populate with settings
    this.minim1.setInputMixer(AudioSystem.getMixer(mixerInfo[this.karaoke.getSettingsManager().getIntegerSetting("mixer1")]));
    this.minim2.setInputMixer(AudioSystem.getMixer(mixerInfo[this.karaoke.getSettingsManager().getIntegerSetting("mixer2")]));

    this.in1 = minim1.getLineIn(Minim.STEREO);
    this.in2 = minim2.getLineIn(Minim.STEREO);
  }

  public AudioInput getAudioInput(int index) {
    if(index == 1) return this.in1;
    if(index == 2) return this.in2;

    return null;
  }

}
