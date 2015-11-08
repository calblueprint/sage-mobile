package blueprint.com.sage.announcements;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;

import com.android.volley.Response;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.events.AnnouncementsListEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.announcements.AnnouncementsListRequest;
import blueprint.com.sage.utility.network.NetworkManager;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListActivity extends FragmentActivity {

   private ArrayList<Announcement> mAnnouncementsList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_announcements);
        mAnnouncementsList = new ArrayList<>();
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        announcementsListRequest();
        transaction.replace(R.id.announcements_container, AnnouncementsListFragment.newInstance()).commit();
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
