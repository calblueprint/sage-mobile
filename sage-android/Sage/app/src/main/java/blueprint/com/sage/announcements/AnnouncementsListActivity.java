package blueprint.com.sage.announcements;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListActivity extends NavigationAbstractActivity {

//   private ArrayList<Announcement> mAnnouncementsList;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        mAnnouncementsList = new ArrayList<>();
        Requests.Announcements request = new Requests.Announcements(this);
        request.makeListRequest();
        FragUtils.replace(R.id.container, AnnouncementsListFragment.newInstance(), this);
    }

//    public void announcementsListRequest() {
//        NetworkManager networkManager = NetworkManager.getInstance(this);
//        AnnouncementsListRequest announcementsRequest = new AnnouncementsListRequest(this, null, new Response.Listener<ArrayList<Announcement>>() {
//            @Override
//            public void onResponse(ArrayList<Announcement> announcementsArrayList) {
//                mAnnouncementsList = announcementsArrayList;
//                EventBus.getDefault().post(new AnnouncementsListEvent());
//            }
//        }, new Response.Listener<APIError>() {
//            @Override
//            public void onResponse(APIError apiError) {
//            }
//        });
//        networkManager.getRequestQueue().add(announcementsRequest);
//    }

//    public void setmAnnouncementsList(ArrayList<Announcement> announcementsList) {
//        mAnnouncementsList = announcementsList;
//    }
//
//    public ArrayList<Announcement> getmAnnouncementsList() {
//        return mAnnouncementsList;
//    }
}
