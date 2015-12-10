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
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Requests.Announcements request = new Requests.Announcements(this);
        request.makeListRequest();
        FragUtils.replace(R.id.container, AnnouncementsListFragment.newInstance(), this);
    }
}
