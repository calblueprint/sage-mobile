package blueprint.com.sage.admin.browse.adapters;

import android.support.v4.app.FragmentActivity;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.UserFragment;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.adapters.models.AbstractUserListAdapter;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 2/3/16.
 */
public class SchoolUserListAdapter extends AbstractUserListAdapter {

    private School mSchool;

    public SchoolUserListAdapter(FragmentActivity activity, School school) {
        super(activity, school.getUsers());
        mSchool = school;
        setUpUsers(mSchool.getUsers());
    }

    public void onItemClick(User user) {
        FragUtils.replaceBackStack(R.id.container, UserFragment.newInstance(user), mActivity);
    }

    public void setUpUsers(List<User> users) {
        mItemList = new ArrayList<>();

        if (mSchool.getDirector() != null) {
            mItemList.add(new Item(null, "Director", true));
            mItemList.add(new Item(mSchool.getDirector(), null, false));
        }

        if (mSchool.getUsers() != null && mSchool.getUsers().size() > 0) {
            mItemList.add(new Item(null, "Mentors", true));

            for (User user : mSchool.getUsers()) {
                mItemList.add(new Item(user, null, false));
            }
        }
    }

    public void setSchool(School school) {
        mSchool = school;
        setUpUsers(school.getUsers());
        notifyDataSetChanged();
    }
}
