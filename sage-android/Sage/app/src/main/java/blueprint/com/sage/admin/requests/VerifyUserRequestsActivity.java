package blueprint.com.sage.admin.requests;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.requests.fragments.VerifyUsersListFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 12/28/15.
 * Shows a list of sign up requests
 */
public class VerifyUserRequestsActivity extends BackAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, VerifyUsersListFragment.newInstance(), this);
    }
}
