package blueprint.com.sage.users.info;

import android.os.Bundle;
import android.widget.Toast;

import com.fasterxml.jackson.core.type.TypeReference;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.users.info.fragments.UserSemesterListFragment;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/15/16.
 */
public class UserSemesterListActivity extends BackAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setUpUser();
        FragUtils.replace(R.id.container, UserSemesterListFragment.newInstance(mUser), this);
    }

    private void setUpUser() {
        Bundle extras = getIntent().getExtras();

        User user = NetworkUtils.writeAsObject(
                this,
                extras.getString(getString(R.string.semester_user)),
                new TypeReference<User>(){});

        if (user == null) {
            Toast.makeText(this, R.string.semester_list_no_user, Toast.LENGTH_SHORT).show();
            finish();
        }

        mUser = user;
    }
}
