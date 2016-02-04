package blueprint.com.sage.admin.semester.adapters;

import android.support.v4.app.FragmentActivity;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.UserFragment;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.adapters.models.AbstractUserListAdapter;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/25/16.
 */
public class SemesterUserListAdapter extends AbstractUserListAdapter {

    private Semester mSemester;

    public SemesterUserListAdapter(FragmentActivity activity, List<User> users, Semester semester) {
        super(activity, users);
        mSemester = semester;
        setUpUsers(users);
    }

    public void setUpUsers(List<User> users) {
        List<Item> allUsers = new ArrayList<>();
        List<Item> inactiveUsers = new ArrayList<>();

        for (User user : users) {
            Item item = new Item(user, null, false);
            allUsers.add(item);

            if (user.getUserSemester() != null && !user.getUserSemester().isActive())
                inactiveUsers.add(item);
        }

        mItemList = new ArrayList<>();

        if (inactiveUsers.size() != 0) {
            mItemList.add(new Item(null, "Inactive Users", true));
            mItemList.addAll(inactiveUsers);
        }

        if (allUsers.size() != 0) {
            mItemList.add(new Item(null, "All Users", true));
            mItemList.addAll(allUsers);
        }
    }

    public void onItemClick(User user) {
        FragUtils.replaceBackStack(R.id.container, UserFragment.newInstance(user, mSemester), mActivity);
    }
}
