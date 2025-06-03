package app.organicmaps.leftbutton;

import com.google.android.material.floatingactionbutton.FloatingActionButton;

public interface LeftButton
{
  String getCode();

  String getPrefsName();

  default void drawIcon(FloatingActionButton imageView) {}

  default void onClick(FloatingActionButton leftButtonView) {}
}
