package blueprint.com.sage.announcements;

import android.os.Bundle;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 1/6/16.
 */
public class AnnouncementActivity extends BackAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        Announcement announcement = null;
        ObjectMapper mapper = new ObjectMapper();
        try {
            announcement = mapper.readValue(getIntent().getStringExtra("Announcement"), Announcement.class);
        } catch (IOException exception) {
            announcement = new Announcement();
        }
        Requests.Announcements.with(this).makeShowRequest(announcement);
        FragUtils.replace(R.id.container, AnnouncementFragment.newInstance(announcement), this);
    }
}

