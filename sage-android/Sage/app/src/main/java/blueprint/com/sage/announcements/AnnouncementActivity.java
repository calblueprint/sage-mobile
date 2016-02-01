package blueprint.com.sage.announcements;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 1/6/16.
 */
public class AnnouncementActivity extends BackAbstractActivity implements AnnouncementInterface {

    private Announcement mAnnouncement;
    private int mType;
    public static final int ORIGINAL = 0;
    public static final int DELETED = 1;
    public static final int EDITED = 2;

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        Announcement announcement = null;
        ObjectMapper mapper = new ObjectMapper();
        try {
            announcement = mapper.readValue(getIntent().getStringExtra("Announcement"), Announcement.class);
            FragUtils.replace(R.id.container, AnnouncementFragment.newInstance(announcement), this);

        } catch (IOException exception) {
            String error = "Announcement";
            Toast.makeText(this, getString(R.string.cannot_be_displayed, error), Toast.LENGTH_SHORT).show();
            onBackPressed();
        }
    }

    public Announcement getAnnouncement() {
        return mAnnouncement;
    }

    public void setAnnouncement(Announcement announcement) {
        mAnnouncement = announcement;
    }

    public int getType() {
        return mType;
    }

    public void setType(int type) {
        mType = type;
    }

    @Override
    public void finish() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        String string;
        switch (mType) {
            case ORIGINAL:
                string = null;
                break;
            default:
                string = getString(R.string.change_announcement);
        }
        bundle.putString(string, NetworkUtils.writeAsString(this, mAnnouncement));
        bundle.putInt(getString(R.string.announcement_type), mType);
        intent.putExtras(bundle);
        setResult(Activity.RESULT_OK, intent);
        super.finish();
    }
}

