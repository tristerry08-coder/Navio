package app.organicmaps.backup;

import static app.organicmaps.backup.BackupUtils.getBackupFolders;
import static app.organicmaps.backup.BackupUtils.getBackupName;
import static app.organicmaps.sdk.util.StorageUtils.copyFileToDocumentFile;
import static app.organicmaps.sdk.util.StorageUtils.deleteDirectoryRecursive;

import android.app.Activity;
import android.net.Uri;
import androidx.annotation.NonNull;
import androidx.documentfile.provider.DocumentFile;
import app.organicmaps.sdk.bookmarks.data.BookmarkCategory;
import app.organicmaps.sdk.bookmarks.data.BookmarkManager;
import app.organicmaps.sdk.bookmarks.data.BookmarkSharingResult;
import app.organicmaps.sdk.bookmarks.data.KmlFileType;
import app.organicmaps.sdk.util.concurrency.ThreadPool;
import app.organicmaps.sdk.util.concurrency.UiThread;
import app.organicmaps.sdk.util.log.Logger;
import java.io.File;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class LocalBackupManager implements BookmarkManager.BookmarksSharingListener
{
  public static final String TAG = LocalBackupManager.class.getSimpleName();

  private final Activity activity;
  private final String backupFolderPath;
  private final int maxBackups;
  private Listener listener;

  public LocalBackupManager(@NonNull Activity activity, @NonNull String backupFolderPath, int maxBackups)
  {
    this.activity = activity;
    this.backupFolderPath = backupFolderPath;
    this.maxBackups = maxBackups;
  }

  public void doBackup()
  {
    BookmarkManager.INSTANCE.addSharingListener(this);

    prepareBookmarkCategoriesForSharing();

    if (listener != null)
      listener.onBackupStarted();
  }

  public void setListener(@NonNull Listener listener)
  {
    this.listener = listener;
  }

  @Override
  public void onPreparedFileForSharing(@NonNull BookmarkSharingResult result)
  {
    BookmarkManager.INSTANCE.removeSharingListener(this);

    ThreadPool.getWorker().execute(() -> {
      ErrorCode errorCode = null;
      switch (result.getCode())
      {
        case BookmarkSharingResult.SUCCESS ->
        {
          if (!saveBackup(result))
          {
            Logger.e(TAG, "Failed to save backup. See system log above");
            errorCode = ErrorCode.FILE_ERROR;
          }
          else
          {
            Logger.i(TAG, "Backup was created and saved successfully");
          }
        }
        case BookmarkSharingResult.EMPTY_CATEGORY ->
        {
          errorCode = ErrorCode.EMPTY_CATEGORY;
          Logger.e(TAG, "Failed to create backup. Category is empty");
        }
        case BookmarkSharingResult.ARCHIVE_ERROR ->
        {
          errorCode = ErrorCode.ARCHIVE_ERROR;
          Logger.e(TAG, "Failed to create archive of bookmarks");
        }
        case BookmarkSharingResult.FILE_ERROR ->
        {
          errorCode = ErrorCode.FILE_ERROR;
          Logger.e(TAG, "Failed create file for archive");
        }
        default ->
        {
          errorCode = ErrorCode.UNSUPPORTED;
          Logger.e(TAG, "Failed to create backup. Unknown error");
        }
      }

      ErrorCode finalErrorCode = errorCode;
      UiThread.run(() -> {
        if (listener != null)
        {
          if (finalErrorCode == null)
            listener.onBackupFinished();
          else
            listener.onBackupFailed(finalErrorCode);
        }
      });
    });
  }

  private boolean saveBackup(@NonNull BookmarkSharingResult result)
  {
    boolean isSuccess = false;
    Uri folderUri = Uri.parse(backupFolderPath);
    try
    {
      DocumentFile parentFolder = DocumentFile.fromTreeUri(activity, folderUri);
      if (parentFolder != null && parentFolder.canWrite())
      {
        LocalDateTime now = LocalDateTime.now();
        DocumentFile backupFolder = BackupUtils.createUniqueBackupFolder(parentFolder, now);
        if (backupFolder != null)
        {
          String backupName = getBackupName(now);
          DocumentFile backupFile = backupFolder.createFile(result.getMimeType(), backupName);
          if (backupFile != null && copyFileToDocumentFile(activity, new File(result.getSharingPath()), backupFile))
          {
            Logger.i(TAG, "Backup saved to " + backupFile.getUri());
            isSuccess = true;
          }
        }
        else
        {
          Logger.e(TAG, "Failed to create backup folder");
        }
      }
      cleanOldBackups(parentFolder);
    }
    catch (Exception e)
    {
      Logger.e(TAG, "Failed to save backup", e);
    }
    return isSuccess;
  }

  public void cleanOldBackups(DocumentFile parentDir)
  {
    DocumentFile[] backupFolders = getBackupFolders(parentDir);
    if (backupFolders.length > maxBackups)
    {
      Arrays.sort(backupFolders, Comparator.comparing(DocumentFile::getName));
      for (int i = 0; i < backupFolders.length - maxBackups; i++)
      {
        Logger.i(TAG, "Delete old backup " + backupFolders[i].getUri());
        deleteDirectoryRecursive(backupFolders[i]);
      }
    }
  }

  private void prepareBookmarkCategoriesForSharing()
  {
    List<BookmarkCategory> categories = BookmarkManager.INSTANCE.getCategories();
    long[] categoryIds = new long[categories.size()];
    for (int i = 0; i < categories.size(); i++)
      categoryIds[i] = categories.get(i).getId();
    BookmarkManager.INSTANCE.prepareCategoriesForSharing(categoryIds, KmlFileType.Text);
  }

  public interface Listener
  {
    void onBackupStarted();

    void onBackupFinished();

    void onBackupFailed(ErrorCode errorCode);
  }

  public enum ErrorCode
  {
    EMPTY_CATEGORY,
    ARCHIVE_ERROR,
    FILE_ERROR,
    UNSUPPORTED,
  }
}
