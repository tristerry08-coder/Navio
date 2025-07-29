package app.organicmaps.editor;

import androidx.annotation.Keep;

// Used by JNI.
@Keep
public class OhState
{
  public enum State
  {
    Open,
    Closed,
    Unknown
  }

  public State state;
  /** Unix timestamp in seconds**/
  public long nextTimeOpen;
  /** Unix timestamp in seconds **/
  public long nextTimeClosed;

  // Used by JNI.
  @Keep
  public OhState(State state, long nextTimeOpen, long nextTimeClosed)
  {
    this.state = state;
    this.nextTimeOpen = nextTimeOpen;
    this.nextTimeClosed = nextTimeClosed;
  }
}
