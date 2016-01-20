package blueprint.com.sage.announcements;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.AnnouncementsListFragment;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListActivity extends BackAbstractActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Requests.Announcements.with(this).makeListRequest(null);
        FragUtils.replace(R.id.container, AnnouncementsListFragment.newInstance(), this);
    }
}
