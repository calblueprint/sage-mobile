package blueprint.com.sage.users;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.users.fragments.EditUserFragment;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/2/16.
 */
public class EditUserActivity extends BackAbstractActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, EditUserFragment.newInstance(getUser()), this);
    }
}
