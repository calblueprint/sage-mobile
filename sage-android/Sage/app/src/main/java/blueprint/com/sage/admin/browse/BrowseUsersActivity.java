package blueprint.com.sage.admin.browse;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.browse.fragments.BrowseUserListFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 12/28/15.
 */
public class BrowseUsersActivity extends BackAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, BrowseUserListFragment.newInstance(), this);
    }
}
