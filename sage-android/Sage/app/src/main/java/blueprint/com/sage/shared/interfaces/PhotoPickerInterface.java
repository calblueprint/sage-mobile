package blueprint.com.sage.shared.interfaces;

import android.content.Intent;

/**
 * Created by charlesx on 2/17/16.
 */
public interface PhotoPickerInterface {
    void startActivityForResult(Intent intent, int requestCode);
    void onRemovePhotoResult();
}
