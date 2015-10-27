package blueprint.com.sage.announcements;

import android.os.Bundle;

import com.android.volley.Response;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.events.AnnouncementsListEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.announcements.AnnouncementsListRequest;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.view.FragUtils;
import de.greenrobot.event.EventBus;


/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListActivity extends NavigationAbstractActivity {

    private ArrayList<Announcement> mAnnouncementsList;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mAnnouncementsList = new ArrayList<>();
        announcementsListRequest();
        FragUtils.replace(R.id.container, AnnouncementsListFragment.newInstance(), this);
    }

    public void announcementsListRequest() {
        NetworkManager networkManager = NetworkManager.getInstance(this);
        AnnouncementsListRequest announcementsRequest = new AnnouncementsListRequest(this, null, new Response.Listener<ArrayList<Announcement>>() {
            @Override
            public void onResponse(ArrayList<Announcement> announcementsArrayList) {
                mAnnouncementsList = announcementsArrayList;
                EventBus.getDefault().post(new AnnouncementsListEvent());
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {
            }
        });
        networkManager.getRequestQueue().add(announcementsRequest);
    }

    public ArrayList<Announcement> getmAnnouncementsList() {
        return mAnnouncementsList;
    }
}
