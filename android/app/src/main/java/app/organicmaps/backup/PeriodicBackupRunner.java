package app.organicmaps.backup;

import static app.organicmaps.backup.BackupUtils.getMaxBackups;
import static app.organicmaps.backup.BackupUtils.isBackupFolderAvailable;
import static app.organicmaps.settings.BackupSettingsFragment.BACKUP_FOLDER_PATH_KEY;
import static app.organicmaps.settings.BackupSettingsFragment.BACKUP_INTERVAL_KEY;
import static app.organicmaps.settings.BackupSettingsFragment.LAST_BACKUP_TIME_KEY;

import android.app.Activity;
import android.content.SharedPreferences;
import androidx.preference.PreferenceManager;
import app.organicmaps.sdk.util.log.Logger;

public class PeriodicBackupRunner
{
  private final Activity activity;
  private static final String TAG = PeriodicBackupRunner.class.getSimpleName();
  private final SharedPreferences prefs;
  private boolean alreadyChecked = false;

  public PeriodicBackupRunner(Activity activity)
  {
    this.activity = activity;
    this.prefs = PreferenceManager.getDefaultSharedPreferences(activity);
  }

  public boolean isAlreadyChecked()
  {
    return alreadyChecked;
  }

  public boolean isTimeToBackup()
  {
    long intervalMs = getBackupIntervalMs();

    if (intervalMs <= 0)
      return false;

    long lastBackupTime = prefs.getLong(LAST_BACKUP_TIME_KEY, 0);
    long now = System.currentTimeMillis();

    alreadyChecked = true;

    return (now - lastBackupTime) >= intervalMs;
  }

  public void doBackup()
  {
    String storedFolderPath = prefs.getString(BACKUP_FOLDER_PATH_KEY, null);

    if (isBackupFolderAvailable(activity, storedFolderPath))
    {
      Logger.i(TAG, "Performing periodic backup");
      performBackup(storedFolderPath, getMaxBackups(prefs));
    }
    else
    {
      Logger.w(TAG, "Backup folder is not writable, passed path: " + storedFolderPath);
    }
  }

  private long getBackupIntervalMs()
  {
    String defaultValue = "0";
    try
    {
      return Long.parseLong(prefs.getString(BACKUP_INTERVAL_KEY, defaultValue));
    }
    catch (NumberFormatException e)
    {
      return 0;
    }
  }

  private void performBackup(String backupFolderPath, int maxBackups)
  {
    LocalBackupManager backupManager = new LocalBackupManager(activity, backupFolderPath, maxBackups);
    backupManager.setListener(new LocalBackupManager.Listener() {
      @Override
      public void onBackupStarted()
      {
        Logger.i(TAG, "Periodic backup started");
      }

      @Override
      public void onBackupFinished()
      {
        prefs.edit().putLong(LAST_BACKUP_TIME_KEY, System.currentTimeMillis()).apply();
        Logger.i(TAG, "Periodic backup finished");
      }

      @Override
      public void onBackupFailed(LocalBackupManager.ErrorCode errorCode)
      {
        Logger.e(TAG, "Periodic backup was failed with code: " + errorCode);
      }
    });

    backupManager.doBackup();
  }
}
