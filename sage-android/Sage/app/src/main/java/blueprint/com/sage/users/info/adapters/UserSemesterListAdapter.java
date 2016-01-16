package blueprint.com.sage.users.info.adapters;

import android.support.v4.app.FragmentActivity;
import android.view.View;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.adapters.models.AbstractSemesterListAdapter;
import blueprint.com.sage.users.info.fragments.UserSemesterFragment;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/15/16.
 */
public class UserSemesterListAdapter extends AbstractSemesterListAdapter {

    private User mUser;

    public UserSemesterListAdapter(FragmentActivity activity, List<Semester> semesters, User user) {
        super(activity, semesters);
        mUser = user;
    }

    public void onItemClicked(View view, Semester semester) {
        FragUtils.replaceBackStack(R.id.container,
                UserSemesterFragment.newInstance(mUser, semester),
                mActivity);
    }
}
