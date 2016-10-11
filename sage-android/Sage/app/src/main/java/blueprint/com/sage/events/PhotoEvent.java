package blueprint.com.sage.events;

import android.content.Intent;

import lombok.Data;

/**
 * Created by charlesx on 10/15/15.
 */
public @Data class PhotoEvent {
    private int requestCode;
    private int resultCode;
    private Intent data;

    public PhotoEvent(int requestCode, int resultCode, Intent data) {
        this.requestCode = requestCode;
        this.resultCode = resultCode;
        this.data = data;
    }
}
