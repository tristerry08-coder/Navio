package app.organicmaps.leftbutton;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import androidx.annotation.Nullable;
import androidx.preference.PreferenceManager;
import app.organicmaps.R;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class LeftButtonsHolder
{
  private static volatile LeftButtonsHolder instance;

  public static final String DISABLE_BUTTON_CODE = "disable";
  public static final String BUTTON_HELP_CODE = "help";
  public static final String BUTTON_SETTINGS_CODE = "settings";
  public static final String BUTTON_ADD_PLACE_CODE = "add-place";
  public static final String BUTTON_RECORD_TRACK_CODE = "record-track";
  private static final String DEFAULT_BUTTON_CODE = BUTTON_HELP_CODE;

  private final String leftButtonPreferenceKey;

  private final SharedPreferences prefs;
  private final Map<String, LeftButton> availableButtons = new LinkedHashMap<>();

  private LeftButtonsHolder(Context context)
  {
    this.prefs = PreferenceManager.getDefaultSharedPreferences(context);
    this.leftButtonPreferenceKey = context.getString(R.string.pref_left_button);
    initDisableButton(context);
  }

  public void registerButton(LeftButton button)
  {
    availableButtons.put(button.getCode(), button);
  }

  @Nullable
  public String getActiveButtonCode()
  {
    String activeButtonCode = prefs.getString(leftButtonPreferenceKey, DEFAULT_BUTTON_CODE);
    if (!TextUtils.isEmpty(activeButtonCode))
      return activeButtonCode;
    else
      return null;
  }

  @Nullable
  public LeftButton getActiveButton()
  {
    return availableButtons.get(getActiveButtonCode());
  }

  public Collection<LeftButton> getAllButtons()
  {
    return availableButtons.values();
  }

  public static LeftButtonsHolder getInstance(Context context)
  {
    LeftButtonsHolder localInstance = instance;
    if (localInstance == null)
    {
      synchronized (LeftButtonsHolder.class)
      {
        localInstance = instance;
        if (localInstance == null)
        {
          instance = localInstance = new LeftButtonsHolder(context);
        }
      }
    }
    return localInstance;
  }

  private void initDisableButton(Context context)
  {
    availableButtons.put(DISABLE_BUTTON_CODE, new LeftButton() {
      @Override
      public String getCode()
      {
        return DISABLE_BUTTON_CODE;
      }

      @Override
      public String getPrefsName()
      {
        return context.getString(R.string.pref_left_button_disable);
      }
    });
  }
}
